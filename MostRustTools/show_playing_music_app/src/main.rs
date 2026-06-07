use mpris::PlayerFinder;
use std::io::Read;
use std::process::{Command, Stdio};
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

fn main() {
    // 1. 清理舊的 cava 進程
    let _ = Command::new("pkill").args(&["-f", "cava"]).status();

    // 2. 用 Rust 的 Command 管道直接啟動 CAVA 並攔截標準輸出
    let mut cava_child = Command::new("cava")
        .args(&["-p", "/home/tamettu_mushroom/.config/waybar/cava.conf"])
        .stdout(Stdio::piped())
        .spawn()
        .expect("無法啟動 cava");

    let mut cava_stdout = cava_child.stdout.take().expect("無法擷取 cava stdout 管道");

    let current_wave = Arc::new(Mutex::new("＿＿＿＿＿＿＿＿".to_string()));
    let current_status = Arc::new(Mutex::new(String::new()));

    // 執行緒 1：抓取 MPRIS 音樂狀態 (每 500ms 刷新)
    let status_clone = Arc::clone(&current_status);
    thread::spawn(move || {
        let finder = PlayerFinder::new().expect("無法初始化 MPRIS 尋找器");
        loop {
            let mut status_text = String::new();
            if let Ok(player) = finder.find_active() {
                if let Ok(metadata) = player.get_metadata() {
                    let song = metadata.title().unwrap_or("未知歌曲");
                    let artists = metadata.artists();
                    let name = artists
                        .and_then(|a| a.first().map(|s| s.to_string()))
                        .unwrap_or_else(|| "未知創作者".to_string());

                    status_text = format!("Name : {} | Song : {}", escape_pango(&name), escape_pango(&clean_title(song)));
                }
            }
            if let Ok(mut status) = status_clone.lock() {
                *status = status_text;
            }
            thread::sleep(Duration::from_millis(500));
        }
    });

    // 執行緒 2：定時輸出給 Waybar (30 FPS)
    let wave_output_clone = Arc::clone(&current_wave);
    let status_output_clone = Arc::clone(&current_status);
    thread::spawn(move || {
        loop {
            let status = status_output_clone.lock().unwrap().clone();
            let wave = wave_output_clone.lock().unwrap().clone();

            if !status.is_empty() {
                println!("{}   {}", status, wave);
            } else {
                println!();
            }
            thread::sleep(Duration::from_millis(33));
        }
    });

    let mut buffer = [0u8; 12];
    
    // 主執行緒：不斷從 CAVA 的 stdout 中精準讀取 12 個二進位位元組
    let mut buffer = [0u8; 12];
    
    // 🔒 修正：全部換成雙引號字串字面量 (&str) 陣列，完美符合 Rust 語法！
    let bars: [&str; 8] = ["＿", "▂", "▃", "▄", "▅", "▆", "▇", "█"];

    while cava_stdout.read_exact(&mut buffer).is_ok() {
        let mut wave = String::new();
        for &val in buffer.iter() {
            let index = match val {
                0..=10 => 0,    // 沒聲音時用等寬的空方塊 " " 頂住，絕對不縮水
                11..=40 => 1,
                41..=80 => 2,
                81..=120 => 3,
                121..=160 => 4,
                161..=195 => 5,
                196..=230 => 6,
                _ => 7,
            };
            // 🔒 修正：因為是 &str，所以改用 push_str() 餵給 String
            wave.push_str(bars[index]);
        }

        // 🔒 修正：防線也改成 push_str(" ")，確保全體等寬
        while wave.chars().count() < 12 {
            wave.push_str(" ");
        }
        let final_wave: String = wave.chars().take(12).collect();

        if let Ok(mut current) = current_wave.lock() {
            *current = final_wave;
        }
    }
}

fn escape_pango(input: &str) -> String {
    input
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
}

fn clean_title(input: &str) -> String {
    input
        .replace(" (Lyrics)", "")
        .replace(" [Lyrics]", "")
        .replace(" (Official Video)", "")
        .replace(" (Official Visualizer)", "")
        .replace(" [CC]", "")
        .replace(" (Official Audio)", "")
}