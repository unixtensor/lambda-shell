use libpse::session;

mod cli;

fn main() {
	if let Some(args) = cli::parser() {
		let shell_config = session::Config {
			norc: args.norc,
			vm: session::VmConfig {
				sandbox: args.nosandbox,
				jit: args.nosandbox
			},
		};
		let mut shell_instance = session::Pse::create(shell_config);
		shell_instance.start();
	};
}