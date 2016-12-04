# FansWatch-API
[ ![Codeship Status for wtlin1228/FansWatch-API](https://app.codeship.com/projects/a5022080-90a3-0134-77c9-3ab596a82ab5/status?branch=master)](https://app.codeship.com/projects/185787)

API to check for feeds and information on public Facebook Pages
ex : 'https://www.facebook.com/cyberbuzz',
     'https://www.facebook.com/time'

## Routes

### GET

- `/` - check if API alive
- `/api/v0.1/page/:page_id` - confirm page id, get name of page
- `/api/v0.1/page/:page_id/feed` - get first page feed of a page
- `/api/v0.1/db_page/?` - get the first row in the database page table

### POST

- `/api/v0.1/page/?url=[FB_PAGE_URL]` - get page by url
- `/api/v0.1/forTest/?` - generate a testcase for spec
- `/api/v0.1/db_page/?url=[FB_PAGE_URL]` - get the posting of the page and update both page and posting table 
