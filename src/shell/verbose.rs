#[allow(dead_code)]
#[derive(Clone, Copy)]
pub struct Verbose {
	verbose: bool,
	extra_color: bool
}

#[allow(dead_code)]
impl Verbose {
	pub fn new(verbose: bool, extra_color: bool) -> Self {
		Self {
			verbose,
			extra_color
		}
	}
	#[inline]
	pub fn eformat(&self, colored: String, noncolored: String) {
		match self.extra_color {
		    true => eprintln!("{colored}"),
		    false => eprintln!("{noncolored}"),
		}
	}
	#[inline]
	pub fn format(&self, colored: String, noncolored: String) {
		match self.extra_color {
		    true => println!("{colored}"),
		    false => println!("{noncolored}"),
		}
	}
	#[inline]
	pub fn eformat_if_verbose(&self, colored: String, noncolored: String) {
		if self.verbose {
			self.eformat(colored, noncolored)
		}
	}
	#[inline]
	pub fn format_if_verbose(&self, colored: String, noncolored: String) {
		if self.verbose {
			self.format(colored, noncolored)
		}
	}
}