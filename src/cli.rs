use clap::Parser;

const VERSION: &str = env!("CARGO_PKG_VERSION");

#[derive(Parser)]
#[command(about, long_about = None)]
pub struct Cli {
	#[arg(short, long)]
	pub version: bool,
	///Extra output mode, primarily used for debugging
	#[arg(long)]
	pub verbose: bool,
	///Built-in shell commands and shell output will be more colorful (Will not work for non-ANSI terminals)
	#[arg(long)]
	pub extra_color: bool,
	///Download and install plugin(s)
	#[arg(long)]
	pub add_plugins: Vec<String>,
	//Remove plugin(s)
	#[arg(long)]
	pub remove_plugins: Vec<String>,
	///Start the shell with no rc configurations
	#[arg(long)]
	pub norc: bool,
	///Disable the Luau JIT backend
	#[arg(long)]
	pub nojit: bool,
}

pub fn version_print(cli_parser: Cli) {
	match cli_parser.extra_color {
	    true => color_print::cprintln!("<cyan,bold>Lambda Shell</>, version <bold>{}</>.", VERSION),
	    false => println!("Lambda Shell, version {}.", VERSION),
	};
}

pub fn parser() -> Option<Cli> {
	let cli_parser = Cli::parse();
	if cli_parser.version {
<<<<<<<< HEAD:src/cli.rs
		println!("Lambda Shell, version: {}.", VERSION);
		println!("liblambdashell, version: {}.", liblambdashell::VERSION);
========
		version_print(cli_parser);
>>>>>>>> master:src/shell/cli.rs
		return None //stop here
	}
	Some(cli_parser)
}