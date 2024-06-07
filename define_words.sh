#!/bin/bash

# Password Manager

# Function to add a new password

# Function to calculate the password strength score
calculate_strength() {
    password=$1
    length=${#password}
    score=0

    # Check for password length
    if [[ $length -ge 8 ]]; then
        ((score+=1))
    else
	echo "Password has less than 8 characters."
    fi

    # Check for lowercase letters
    if [[ $password =~ [a-z] ]]; then
        ((score+=1))
    else
        echo "Password is missing lowercase letters."
    fi

    # Check for uppercase letters
    if [[ $password =~ [A-Z] ]]; then
        ((score+=1))
    else
        echo "Password is missing uppercase letters."
    fi

    # Check for numbers
    if [[ $password =~ [0-9] ]]; then
        ((score+=1))
    else
        echo "Password is missing numbers."
    fi

    # Check for special characters
    if [[ $password =~ [[:punct:]] ]]; then
        ((score+=1))
    else
        echo "Password is missing special characters."
    fi

    # Print the score
    echo "Password Strength Score: $score/5"
}


encrypt_file() {
    local file=$1
    gpg --symmetric --cipher-algo AES256 --output "${file}.gpg" "$file" > /dev/null 2>&1
    echo "File encrypted: ${file}.gpg"
}


#Function to decrypt a file
decrypt_file() {
    local encrypted_file=$1
    gpg --decrypt --output "${encrypted_file%.gpg}" "$encrypted_file" > /dev/null 2>&1
    #(echo "File decrypted: ${encrypted_file%.gpg}")
}


add_password() {
    local file=$1

    echo "Enter the account name: "
    read temp_account
    # Lowercase the name of the account
    account=$(echo "$temp_account" | tr '[:upper:]' '[:lower:]')

    # Verify if the entry already exists
    if grep -qi "$account" "$file"; then
	echo "Entry exists in the database."
	return # This will exit the function for finding that the entry already exists
    else
	echo "Choose an option: "
	echo "1. Random Password Generator"
	echo "2. Manual Password Entry"

	echo "Enter your choice: "
	read pwd_choice

	case $pwd_choice in
        1)
            answer="Y"
	    while true; do
		# Generate and print a random password
           	password=$(pwgen -s -1cny 12 | head -n 1)
           	echo "Generated Password: $password"

	        # Check if user like the generated password
		echo "Do you like this password? (Y/N): "
		read answer

	    	case "$answer" in
		   [Yy])
			break
			;;
		   [Nn])
			echo "You selected No. Generating a new password..."
			;;
		   *)
			echo "Invalid entry. Please enter Y or N."
			read answer
			;;
		esac
	    done

	    # Save the account and password to the password file (assuming the file is named words.txt)
            echo "$account:$password" >> "$file"
            echo "Password added successfully!"

	    # Copy password to clipboard
	    echo -n "$password" | xclip -selection clipboard
	    echo "Generated Password (copied to clipboard): $password"
            ;;

        2)
            # Manually enter the password
            echo "Enter the password: "
	    read password

	    # Check password strength
	    calculate_strength  "$password"

            # Save the account and password to the password file (assuming the file is named words.txt)
            echo "$account:$password" >> "${file}"
            echo "Password added successfully!"

	    # Copy password to clipboard
	    echo -n "$password" | xclip -selection clipboard
	    echo "Generated Password (copied to clipboard): $password"
            ;;
        esac
    fi

}

# Function to retrieve a password
retrieve_password() {
    local file=$1

    echo "Enter the account name: "
    read temp_account
    # Lowercase the name of the account
    account=$(echo "$temp_account" | tr '[:upper:]' '[:lower:]')

    # Search for the account in the password file and display the corresponding password
    password=$(grep "^$account:" "$file" | cut -d ':' -f 2)
    if [[ -n $password ]]; then
	echo "Account found!"
        echo "Password: $password"

	# Copy password to clipboard
        echo -n "$password" | xclip -selection clipboard
        echo "Generated Password (copied to clipboard): $password"

    else
        echo "Account not found!"
    fi
}

# Function to update a password
update_password() {
    local file=$1
    echo "Enter the account name: "
    read temp_account
    # Lowercase the name of the account
    account=$(echo "$temp_account" | tr '[:upper:]' '[:lower:]')

    # Search for the account in the password file and update the corresponding password
    grep -q "^$account:" "$file"
    if [[ $? -eq 0 ]]; then
	echo "Account found!"
        echo "Choose an option: "
        echo "1. Random Password Generator"
        echo "2. Manual Password Entry"

        echo "Enter your choice: "
        read pwd_choice

        case $pwd_choice in
        1)
            answer="Y"
            while true; do
                # Generate and print a random password
                new_password=$(pwgen -s -1cny 12 | head -n 1)
                echo "Generated Password: $new_password"

                echo "Do you like this password? (Y/N): "
                read answer

                case "$answer" in
                   [Yy])
                        break
                        ;;
                   [Nn])
                        echo "You selected No. Generating a new password..."
                        ;;
                   *)
                        echo "Invalid entry. Please enter Y or N."
                        read answer
                        ;;
                esac
            done

	    # Save the new password to the password file (assuming the file is named words.txt)
            sed -i "s/^$account:.*/$account:$new_password/" "$file"

	    echo "Password added successfully!"

            # Copy password to clipboard
            echo -n "$new_password" | xclip -selection clipboard
            echo "Generated Password (copied to clipboard): $new_password"

            ;;
        2)
            # Manually enter the password
            echo "Enter the new  password: "
            read new_password

            calculate_strength  "$new_password"

            # Save the new password to the password file (assuming the file is named words.txt)
	    sed -i "s/^$account:.*/$account:$new_password/" "$file"

            echo "Password added successfully!"

            # Copy password to clipboard
            echo -n "$new_password" | xclip -selection clipboard
            echo "Generated Password (copied to clipboard): $new_password"

            ;;
        esac

    else
        echo "Account not found!"
    fi
}

# Function to delete a password
delete_password() {
    echo "Enter the account name: "
    read temp_account
    # Lowercase the name of the account
    account=$(echo "$temp_account" | tr '[:upper:]' '[:lower:]')

    # Search for the account in the password file and remove the corresponding entry
    grep -q "^$account:" "$file"
    if [[ $? -eq 0 ]]; then
	echo "Account found!"
        sed -i "/^$account:/d" "$file"
        echo "Password deleted successfully!"
    else
        echo "Account not found!"
    fi
}

# Main menu

file="words.txt"

#decrypt_file "${file}.gpg"
#rm "${file}.gpg"


while true; do
    echo
    echo "Password Manager"
    echo "1. Add password"
    echo "2. Retrieve password"
    echo "3. Update password"
    echo "4. Delete password"
    echo "5. Exit"

    echo "Enter your choice: "
    read choice

    case $choice in
        1)
            add_password "$file"
            ;;
        2)
            retrieve_password "$file"
            ;;
        3)
            update_password "$file"
            ;;
        4)
            delete_password "$file"
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice!"
            ;;
    esac
    echo ""
    echo "Would you like to continue? (Y/N): "
    read answer

    while true; do
    case "$answer" in
        [Yy])
            break
	    ;;
        [Nn])
            echo "You selected No."
            exit 0
            ;;
        *)
            echo "Invalid entry. Please enter Y or N."
            read answer
            ;;
    esac
    done

#encrypt_file "$file"
#rm "$file"


done
