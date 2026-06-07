use std::env;
use std::process::Command;
fn main() {
    let target: String = env::args().nth(1).expect("idk");
    match Command::new("pkill")
        .arg("-f")
        .arg(format!("^waybar -c {}", target))
        .status()
        .expect("idk")
        .code()
    {
        Some(0) => {
            println!("yoyoyo");
            return;
        }
        _ => (),
    }
    Command::new("waybar")
        .arg("-c")
        .arg(format!("{}.jsonc", target))
        .arg("-s")
        .arg(format!("{}.css", target))
        .spawn()
        .expect("idk");
}
