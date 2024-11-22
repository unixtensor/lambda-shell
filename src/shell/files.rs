use std::{fs::{self, ReadDir}, io::Error, path::{Path, PathBuf}};

pub enum FsError {
	SetDir(Error),
	ReadDir(Error)
}

pub fn set_current_dir(new_path: &Path) -> Result<PathBuf, FsError> {
	std::env::set_current_dir(new_path).map(|_| new_path.to_path_buf()).or_else(|new_path_err| Err(FsError::SetDir(new_path_err)))
}

pub fn read_dir(path: &Path) -> Result<ReadDir, FsError> {
	fs::read_dir(path).or_else(|read_dir_error| Err(FsError::ReadDir(read_dir_error)))
}