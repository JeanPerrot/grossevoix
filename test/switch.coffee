sw = require '../src/sonos/switch'

url1 ='http://translate.google.com/translate_tts?tl=en&q=Welcome%20home%20Aiden'
url1 = 'http://translate.google.com/translate_tts?tl=en&q=Hello%20world'
# url1 = 'http://media.tts-api.com/8aa5d56a065f13bd925ee28d95c509434716e66d.mp3'
# url1 = 'http://livingears.com/music/SceneNotHeard/091909/Do%20You%20Mind%20Kyla.mp3'
url1 = 'http://www.miss-music.com/music/pomp_loop.mp3'

#url1 = 'http://192.168.1.174:49160/mp3'
describe 'switching', ->
  it 'should play', (done)->
    this.timeout 20000
    console.log url1
    sw.play_now url1, (err, playing)->
      console.log err if err?
      done()
