mod cli;

fn main() {
	if let Some(args) = cli::parser() {
		let shell_config = libpse::session::Config {
			norc: args.norc,
			nojit: args.nojit,
			nosandbox: args.nosandbox,
		};
		let mut shell_instance = libpse::session::LambdaShell::create(shell_config);
		shell_instance.start();
	};
}