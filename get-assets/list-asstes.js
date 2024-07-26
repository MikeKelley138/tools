const puppeteer = require('puppeteer');
const fs = require('fs');

(async () => {
    console.log('Starting script');

    try {
        console.log('Launching browser');
        const browser = await puppeteer.launch({ headless: true });
        const page = await browser.newPage();

        const url = 'https://staging.capitalgazette.com';
        console.log(`Navigating to ${url}...`);
        await page.goto(url, { waitUntil: 'networkidle2' });

        const requests = [];
        console.log(`Page Origin: ${new URL(url).origin}`);

        page.on('request', request => {
            console.log(`Request URL: ${request.url()}`);
            requests.push(request.url());
        });

        // Use page.waitFor with a timeout in milliseconds
        await page.waitFor(15000);  // Wait for 15 seconds

        await browser.close();
        console.log('Browser has closed');

        // Writing the results to a file
        const outputFilePath = 'all_requests.txt';
        fs.writeFileSync(outputFilePath, requests.join('\n'), 'utf8');

        console.log(`All requests written to ${outputFilePath}`);

    } catch (error) {
        console.log('There was an error');
        console.error(error);
    }
})();
