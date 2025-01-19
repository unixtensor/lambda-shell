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
	///Download and install plugin(s)
	#[arg(long)]
	pub add_plugins: Vec<String>,
	///Remove plugin(s)
	#[arg(long)]
	pub remove_plugins: Vec<String>,
	///Start the shell with no rc configurations
	#[arg(long)]
	pub norc: bool,
	///Disable the Luau JIT backend
	#[arg(long)]
	pub nojit: bool,
	///Disable the Luau sandbox
	#[arg(long)]
	pub nosandbox: bool,
}

pub fn parser() -> Option<Cli> {
	let cli_parser = Cli::parse();
	if cli_parser.version {
		println!("lambdashell, version: {}.", VERSION);
		println!("liblambdashell, version: {}.", libpse::VERSION);
		return None //stop here
	}
	Some(cli_parser)
}