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
        await page.goto(url, { waitUntil: 'networkidle2', timeout: 60000 }); // Increased timeout to 60 seconds

        const requests = [];

        page.on('request', request => {
            const requestURL = new URL(request.url());
            console.log(`Captured Request: ${request.url()} - Origin: ${requestURL.origin}`);
            requests.push({ url: request.url(), origin: requestURL.origin });
        });

        // Wait longer to ensure all requests are captured
        await page.waitForTimeout(30000);  // Increased wait time to 30 seconds

        await browser.close();
        console.log('Browser has closed');

        // Writing all requests to a file
        const allRequestsFilePath = 'all_requests.txt';
        fs.writeFileSync(allRequestsFilePath, requests.map(req => req.url).join('\n'), 'utf8');

        console.log(`All requests written to ${allRequestsFilePath}`);

    } catch (error) {
        console.log('There was an error');
        console.error(error);
    }
})();
