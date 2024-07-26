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
        await page.goto(url, { waitUntil: 'networkidle2', timeout: 60000 }); // Increase timeout to 60 seconds

        const requests = [];
        const pageOrigin = new URL(url).origin;
        console.log(`Page Origin: ${pageOrigin}`);

        page.on('request', request => {
            const requestURL = new URL(request.url());
            const requestOrigin = requestURL.origin;
            requests.push({ url: request.url(), origin: requestOrigin });
        });

        // Wait longer to ensure all requests are captured
        await page.waitForTimeout(15000);  // Increased wait time

        await browser.close();
        console.log('Browser has closed');

        // Filter internal requests
        const internalRequests = requests.filter(req => req.origin === pageOrigin);

        // Output internal requests to console
        console.log('Internal requests:');
        internalRequests.forEach(req => console.log(req.url));

        // Writing internal requests to a file
        const internalFilePath = 'internal_assets.txt';
        fs.writeFileSync(internalFilePath, internalRequests.map(req => req.url).join('\n'), 'utf8');

        console.log(`Internal assets written to ${internalFilePath}`);

    } catch (error) {
        console.log('There was an error');
        console.error(error);
    }
})();
