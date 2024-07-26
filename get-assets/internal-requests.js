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
        const pageOrigin = new URL(url).origin;
        console.log(`Page Origin: ${pageOrigin}`);

        page.on('request', request => {
            const requestURL = new URL(request.url());
            const requestOrigin = requestURL.origin;
            // Log all requests to ensure we see what's being captured
            console.log(`Captured Request: ${request.url()} - Origin: ${requestOrigin}`);
            requests.push({ url: request.url(), origin: requestOrigin });
        });

        // Wait longer to ensure all requests are captured
        await page.waitForTimeout(30000);  // Increased wait time to 30 seconds

        await browser.close();
        console.log('Browser has closed');

        // Filter internal requests
        const internalRequests = requests.filter(req => req.origin === pageOrigin);

        // Output internal requests to console
        if (internalRequests.length > 0) {
            console.log('Internal requests:');
            internalRequests.forEach(req => console.log(req.url));
        } else {
            console.log('No internal requests found.');
        }

        // Writing internal requests to a file
        const internalFilePath = 'internal_assets.txt';
        fs.writeFileSync(internalFilePath, internalRequests.map(req => req.url).join('\n'), 'utf8');

        console.log(`Internal assets written to ${internalFilePath}`);

    } catch (error) {
        console.log('There was an error');
        console.error(error);
    }
})();
