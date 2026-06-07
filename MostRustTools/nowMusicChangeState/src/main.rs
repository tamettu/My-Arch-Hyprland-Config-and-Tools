use regex::Regex;
use std::fs;
use std::process::Command;

fn main() {
    let content = fs::read_to_string("/home/tamettu_mushroom/.config/hypr/hyprland.lua").unwrap();
    let re = Regex::new(r"changeableOutsideGap\s*=\s*\{[^}]*\} -- change by rust script").unwrap();
    match Command::new("pkill")
        .arg("-f")
        .arg("nowMusic.jsonc")
        .status()
        .expect("idk")
        .code()
    {
        Some(0) => {
            let updated_content = re.replace(&content, "changeableOutsideGap = {top = 5, left = 5, right = 5, bottom = 5} -- change by rust script").into_owned();
            fs::write(
                "/home/tamettu_mushroom/.config/hypr/hyprland.lua",
                updated_content,
            )
            .unwrap();
            return;
        }
        _ => (),
    }
    Command::new("waybar")
        .arg("-c")
        .arg("/home/tamettu_mushroom/.config/waybar/Default/nowMusic.jsonc")
        .arg("-s")
        .arg("/home/tamettu_mushroom/.config/waybar/Default/nowMusic.css")
        .spawn()
        .expect("idk");
    let updated_content = re.replace(&content, "changeableOutsideGap = {top = 34, left = 5, right = 5, bottom = 5} -- change by rust script").into_owned();
    fs::write(
        "/home/tamettu_mushroom/.config/hypr/hyprland.lua",
        updated_content,
    )
    .unwrap();
}
