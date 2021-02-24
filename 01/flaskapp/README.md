# Emoji Decoration Flask App
## Description
The application accepts api requests on port 80 and return a string decorated with random emoji.

## JSON API
POST request to the root of server:
```json
{
  "word": "test", // string to decorate
  "count": "3",   // how many decorated strings to return
}
```

## Example
```sh
curl -s -XPOST -H "Content-Type: application/json" -d '{"word":"test","count":3}' http://host/
```

