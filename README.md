# FansWatch-API
[ ![Codeship Status for wtlin1228/FansWatch-API](https://app.codeship.com/projects/a5022080-90a3-0134-77c9-3ab596a82ab5/status?branch=master)](https://app.codeship.com/projects/185787)

API to check for feeds and information on public Facebook Pages

## Routes

### GET

- `/` - check if API alive
- `/api/v0.1/page/:page_id` - confirm page id, get name of page
- `/api/v0.1/page/:page_id/feed` - get first page feed of a page

### POST

- `/api/v0.1/page/?url=[FB_PAGE_URL]` - get page by url
