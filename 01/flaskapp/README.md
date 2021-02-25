# Emoji Decoration Flask App
## Description
The application accepts api requests on port 80 and returns a string decorated with random emoji.

## JSON API
POST request to the root of server:
```json
{
  "word": "<string_to_decorate>",
  "count": <number_of_repeats>,
}
```

## Example
```sh
curl -s -XPOST -H "Content-Type: application/json" -d '{"word":"test","count":3}' http://host/
```

