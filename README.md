# Johns Solution For Word Count Validator

## To Run:

  1. first run a mongod service as the captcha models rely on it for storage (the default port 28017 will do).

  2. Then run the run script which starts server. It is on localhost:8000

  3. Some basic rspec tests are under spec directory that tests for get, post, post with old data (not okay as each captcha should only be used once), and wrong answers

## Assumptions And Decisions:

  1. What's message format? Json objects is the natural choice as it is both the standard, is small and easy to parse and is the format of the helper erb template. Assumption here is that messages are done via http protocal in json format, which seems reasonable one for a modern webservice. (Of course, there the whole bit about aliens being able to use a json api, but that's story for another day....)

  2. What language to use? Node.js was the first to come to mind as we are already sending things via Json, decided against it as I wanted to try something new, so....

  3. Which server? First one that came to mind was using rails and webrick, decided against it as it's too heavy, Sinatra and rack seems like good choices while I went over the specs... There's also Thin, Mongrel, etc. But decided to roll my own as it didn't seem very hard using the sockets library and seemed like a fun way to learn some nitty gritties of web servers.

  4. Which leads to... looks like I should roll my own app for it as well. Seems straightforward enough to do a basic MVCish app without having to resort to something heavy. Went with Mongo for basic storage instead of sqlite (doesn't really matter as each captcha is only one item in either case)

  5. Those were the major choices, probably could've gone with a light weight framework to do the same thing in about the same amount of time, but then I wouldn't spend an hour learning how POST body needs to be read in chunks :)
