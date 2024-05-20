console.log('starting script');

const puppeteer = require('puppeteer');

(async () => {
    console.log('async working');
    try {
        console.log('launching browser');
        const browser = await puppeteer.launch({headless:true});
        const page = await browser.newPage();

        const url = 'https://staging.capitalgazette.com';
        console.log(`navigating to ${url}...`);
        await page.goto(url, {waitUntil: 'networkidle0'});

        const requests = [];
        page.on('request', request =>{
            requests.push(request.url()); //use this line for only external resources
            //const pageURL = new URL(url);
            //const requestURL = new URL(request.url());
            /*if(requestURL.origin === pageURL.origin){
                requests.push(request.url());
            }*/
        });

        await new Promise(resolve => setTimeout(resolve, 50000));

        await browser.close();
        console.log('browser has closed');

        //const assetTypes = ['.css' , '.js'];
        //const assets = requests.filter(url =>assetTypes.some(type => url.endsWith(type)) );

        //console.log(requests);


        console.log('assets loaded by page:');
        requests.forEach(url => console.log(url));

    } catch (error) {
        console.log('there was an error');
    }
} )();