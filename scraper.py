import requests
from bs4 import BeautifulSoup
import csv
import os
from urllib.parse import urlparse

def save_text_to_file(text, filename):
    print(f"Writing {text}")
    with open(filename, 'a+', encoding='utf-8') as file:
        file.write(text + '\n\n')

def log_url_to_csv(key, url):
    with open("/files/visited_urls.csv", 'a', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow([key, url])

def remove_non_ascii(text):
    return ''.join(char for char in text if ord(char) < 128)

def scrape_text(url, visited_urls, visited_domains, csv=False):
    if url in visited_urls:
        return
    visited_urls.add(url)

    if not csv:
        # Ask the user if they want to scrape this URL
        user_input = input(f"Do you want to scrape the URL: {url}? (y/n): ").strip().lower()
        if user_input != 'y':
            print(f"Skipping {url}.")
            return

    print(f"Scraping {url}")
    
    try:
        base_domain = urlparse(url).netloc
        output_file = f"/files/input/{base_domain}.txt"
        if base_domain not in visited_domains:
            visited_domains.add(base_domain)
            # Create new file/overwrite previous runs
            with open(output_file, 'w+', encoding='utf-8') as file:
                file.write("")

        response = requests.get(url)
        response.raise_for_status()  # Raise an error for bad responses
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Collect text from the main page
        page_text = soup.get_text(separator='\n').strip()
        page_text = remove_non_ascii(page_text)
        save_text_to_file(page_text, output_file)

        if not csv:
            # Log the visited URL to CSV
            log_url_to_csv(base_domain, url)
            # Follow links
            for link in soup.find_all('a', href=True):
                full_link = requests.compat.urljoin(url, link['href'])
                parsed_link = urlparse(full_link)

                # Only follow links from the same domain and ignore anchor links
                if parsed_link.netloc == base_domain and not parsed_link.fragment:
                    scrape_text(full_link, visited_urls, visited_domains)

    except Exception as e:
        print(f"Failed to scrape {url}: {e}")

def main():
    directory = '/files/input'
    if not os.path.exists(directory):
        os.makedirs(directory)

    visited_urls = set()
    visited_domains = set()
    option = input("Do you want to enter a URL manually (m) or scrape URLs from a CSV file (c)? (m/c): ").strip().lower()

    if option == 'm':
        starting_url = input("Enter the URL to scrape: ")
        scrape_text(starting_url, visited_urls, visited_domains)
    else:
        try:
            with open("/files/visited_urls.csv", 'r', encoding='utf-8') as csvfile:
                reader = csv.reader(csvfile)
                for row in reader:
                    if row:  # Ensure the row is not empty
                        url = row[1]
                        scrape_text(url, visited_urls, visited_domains, True)
        except Exception as e:
            print(f"Error reading CSV file: {e}")
    
    for domain in visited_domains:
        print(f"Scraping complete! Collected text saved to '/files/input/{domain}.txt'.")

if __name__ == "__main__":
    main()