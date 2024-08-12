from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.firefox.service import Service as FirefoxService
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
import time

def run_test(browser_type):
    if browser_type == 'chrome':
        options = ChromeOptions()
        options.add_argument('--headless')
        driver_path = '/path/to/chromedriver'
        service = ChromeService(executable_path=driver_path)
        browser = webdriver.Chrome(service=service, options=options)
    elif browser_type == 'firefox':
        options = FirefoxOptions()
        options.add_argument('--headless')
        driver_path = '/path/to/geckodriver'
        service = FirefoxService(executable_path=driver_path)
        browser = webdriver.Firefox(service=service, options=options)
    
    try:
        browser.get('http://example.com')
        
        # Use an explicit wait to wait until the element is clickable
        link_element = WebDriverWait(browser, 10).until(
            EC.element_to_be_clickable((By.ID, 'your_element_id'))
        )
        
        # Ensure the element is visible in the viewport
        ActionChains(browser).move_to_element(link_element).perform()

        # Scroll to the element if needed
        browser.execute_script("arguments[0].scrollIntoView(true);", link_element)
        
        link_element.click()

        start_time = time.time()
        browser.implicitly_wait(10)
        end_time = time.time()
        load_time = end_time - start_time

        print(f"{browser_type.capitalize()} page load time: {load_time} seconds")

    finally:
        browser.quit()

# Run tests for both Chrome and Firefox
run_test('chrome')
run_test('firefox')
