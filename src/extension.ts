// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import {
	LanguageClient,
	LanguageClientOptions,
	ServerOptions,
	TransportKind
  } from 'vscode-languageclient/node';
import * as path from 'path';

let client: LanguageClient;

// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {
	// Use the console to output diagnostic information (console.log) and errors (console.error)
	// This line of code will only be executed once when your extension is activated
	// console.log('Congratulations, your extension "etude-language-support" is now active!');

	// The command has been defined in the package.json file
	// Now provide the implementation of the command with registerCommand
	// The commandId parameter must match the command field in package.json
	// const disposable = vscode.commands.registerCommand('etude-language-support.helloWorld', () => {
	// 	// The code you place here will be executed every time your command is executed
	// 	// Display a message box to the user
	// 	vscode.window.showInformationMessage('Hello World from Etude language support!');
	// });

	// context.subscriptions.push(disposable);

	let clientOptions: LanguageClientOptions = {
		// Register the server for plain text documents
		documentSelector: [{ scheme: 'file', language: 'etude' }], // <- etude!
	};

	let serverPath = context.asAbsolutePath(path.join('lsp-server', 'server'));
	let serverOptions: ServerOptions = {
	  command: serverPath, // module:, если бы language server был написан на nodejs typescript или javascript.
	  transport: TransportKind.stdio,
	};

	// Create the language client and start the client.
	client = new LanguageClient(
		'EtudeLanguageServer',
		'Language Server for Etude programming language',
		serverOptions,
		clientOptions
	);
	
	// Start the client. This will also launch the server
	client.start();
}

// This method is called when your extension is deactivated
export function deactivate(): Thenable<void> | undefined {
	if (!client) {
		return undefined;
	}
	return client.stop();
}
