sw = require '../src/sonos/switch'

url1 ='http://translate.google.com/translate_tts?tl=en&q=Welcome%20home%20Aiden'
url1 = 'http://media.tts-api.com/8aa5d56a065f13bd925ee28d95c509434716e66d.mp3'
url = 'http://livingears.com/music/SceneNotHeard/091909/Do%20You%20Mind%20Kyla.mp3'
describe 'switching', ->
  it 'should play', (done)->
    this.timeout 20000
    sw.play_now url1, (err, playing)->
      done()
