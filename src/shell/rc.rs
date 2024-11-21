use std::{fs, path::{self, PathBuf}};
use crate::shell;

trait PathBufOnly {}
impl PathBufOnly for PathBuf {}
type ConfigResult<T: PathBufOnly> = Result<T, ConfigError>;

pub enum ConfigError {
	HomeDirectory,
	DotConfigMissing,
	DotConfigInvalid,
	ConfigFolderInvalid,
	MainFolderCreation,
}

fn home_dir() -> ConfigResult<path::PathBuf> {
	home::home_dir().ok_or(ConfigError::HomeDirectory)
}

fn home_config_dir() -> ConfigResult<path::PathBuf> {
	let mut config_dir = home_dir()?;
	config_dir.push(".config");
	if config_dir.try_exists().is_ok() {
		if config_dir.is_dir() {
			return Ok(config_dir)
		}
		return Err(ConfigError::DotConfigInvalid)
	}
	Err(ConfigError::DotConfigMissing)
}

fn get_or_create_folder(folder_buf: &path::PathBuf) -> Option<&path::PathBuf> {
	folder_buf.try_exists().is_ok().then_some(folder_buf).or_else(move || match fs::create_dir(folder_buf) {
		Ok(_) => Some(folder_buf),
		Err(_) => None
	})
}

// fn init_folders(config: shell::Config, lambdashell_config_pathbuf: &mut path::PathBuf) -> ConfigResult<(Option<&path::PathBuf>, Option<&path::PathBuf>)> {
// 	match fs::create_dir(&lambdashell_config_pathbuf) {
// 	    Ok(()) => {
// 			let mut config_folder_clone = lambdashell_config_pathbuf.clone();
// 			let mut plugins_folder_clone = lambdashell_config_pathbuf.clone();
// 			config_folder_clone.push("config");
// 			plugins_folder_clone.push("plugins");

// 			let config_folder = get_or_create_folder(&config_folder_clone);
// 			let plugins_folder = get_or_create_folder(&plugins_folder_clone);

// 			Ok((config_folder, plugins_folder))
// 		},
// 	    Err(_) => Err(ConfigError::MainFolderCreation),
// 	}
// }

pub fn config_directory(config: shell::Config) {
	// let mut home_dot_config = home_config_dir()?;
	// let config_file_path = extend_pathbuf(&mut home_dot_config, "lambdashell");

	// if config_file_path.exists() {
	// 	if config_file_path.is_dir() {
	// 		return Ok(config_file_path)
	// 	} else {
	// 		return Err(ConfigError::ConfigFolderInvalid)
	// 	}
	// } else {
	// 	let init_files = init_folders(config, &mut home_dot_config)?;
	// 	let config_folder = init_files.0?;
	// 	let plugins_folder = init_files.1?;

	// }
}