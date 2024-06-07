# Password Manager: Secure Password Management and Encryption Project

## Overview

This project is a secure and user-friendly password manager written in Bash. It includes functionalities for adding, retrieving, updating, and deleting passwords, ensuring user data is securely managed and easily accessible. Key features include password strength calculation, file encryption and decryption, random password generation, and clipboard integration. The script provides an interactive menu-driven interface for a seamless user experience.

## Features

- **Password Strength Calculation**: Evaluates password strength based on length, inclusion of lowercase and uppercase letters, numbers, and special characters.
- **Password Encryption and Decryption**: Utilizes `gpg` for symmetric encryption and decryption of the password file to ensure data security.
- **Random Password Generation**: Offers an option to generate secure random passwords using `pwgen` and copies them to the clipboard for convenience.
- **Clipboard Integration**: Automatically copies passwords to the clipboard when they are added or retrieved.
- **User-Friendly Interface**: Interactive menu-driven interface allowing users to choose from various options (add, retrieve, update, delete, exit) with validation checks and user feedback.

## Requirements

- Bash
- `gpg` (GNU Privacy Guard)
- `pwgen` (Password Generator)
- `xclip` (Clipboard utility for X)

## Installation

1. **Install `gpg`**:
    ```sh
    sudo apt-get install gnupg
    ```

2. **Install `pwgen`**:
    ```sh
    sudo apt-get install pwgen
    ```

3. **Install `xclip`**:
    ```sh
    sudo apt-get install xclip
    ```

4. **Clone the repository**:
    ```sh
    git clone https://github.com/yourusername/password-manager.git
    cd password-manager
    ```

## Usage

1. **Run the script**:
    ```sh
    ./password_manager.sh
    ```

2. **Follow the interactive menu** to add, retrieve, update, or delete passwords.

## Script Breakdown

### Password Strength Calculation

The script evaluates the strength of passwords based on length, inclusion of lowercase and uppercase letters, numbers, and special characters, providing a score out of 5.

### Encryption and Decryption

- **Encrypt File**:
    ```sh
    gpg --symmetric --cipher-algo AES256 --output "${file}.gpg" "$file"
    ```

- **Decrypt File**:
    ```sh
    gpg --decrypt --output "${encrypted_file%.gpg}" "$encrypted_file"
    ```

### Password Management Functions

- **Add Password**: Adds a new password entry, with options for random generation or manual entry.
- **Retrieve Password**: Retrieves and displays a password for a given account, copying it to the clipboard.
- **Update Password**: Updates an existing password, with options for random generation or manual entry.
- **Delete Password**: Deletes a password entry for a given account.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Acknowledgments

This project was inspired by the need for a simple, secure, and effective way to manage passwords directly from the command line. Special thanks to the developers of `gpg`, `pwgen`, and `xclip` for their invaluable tools.
