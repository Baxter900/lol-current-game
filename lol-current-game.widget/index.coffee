apiKey = '' # put your api key here, you can get one at: https://developer.riotgames.com/
summonerApiVersion = 'v1.4' # Note the v before the version number
staticApiVersion = 'v1.2' # Note the v before the version number


summonerName = '' # Put your summoner name here

regionName = 'na'

specialRegionName = '' # Valid names are: NA1, BR1, LA1, LA2, OC1, EUN1, TR1, RU, EUW1, KR

command: "curl -s 'https://#{regionName}.api.pvp.net/api/lol/#{regionName}/#{summonerApiVersion}/summoner/by-name/#{summonerName}?api_key=#{apiKey}'"

refreshFrequency: 10000  # Fastest updating you can do with a standard dev key is 1200

style: """
  top: 360px
  left: 85px
  z-index: 33
  text-align: center
  horizontal-align: center
  border: solid 1px rgba(#fff, 0.6)
  background: rgba(#fff, 0.15)

  .spell-icon
    display: inline-block

  .champion-icon
    display: block
    margin-left: auto
    margin-right: auto

  .champion-icon, .spell-icon
    border-radius: 25px

  .name
    display: table-cell
    color: #fff
    font-family: Helvetica Neue
    font-size: 14px
    max-width: 200px
    text-transform: uppercase
    font-weight: 200
    letter-spacing: 0.025em
    font-smoothing: antialiased
    line-height: 0.9em
    text-shadow: 1px 1px 0px rgba(0, 0, 0, .4)
    vertical-align: top
    width: 100px
    height: 25px
    padding: 3px 0px 0px 0px

  .name:empty
    width: 0px
    height: 0px
    padding: 0px

  #team2
    border-left: solid 1px rgba(#fff,1)

  .team
    padding: 25px 0px 0px 0px

"""


render: -> """
  <div class="info"></div>
  <table>
    <tr>
      <td class="team" id="team1">
        <table>
          <tr class="player" id="player1">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
          <tr class="player" id="player2">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
          <tr class="player" id="player3">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
          <tr class="player" id="player4">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
          <tr class="player" id="player5">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
          <tr class="player" id="player6">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
        </table>
      </td>
      <td class="team" id="team2">
        <table>
          <tr class="player" id="player1">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
          <tr class="player" id="player2">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
          <tr class="player" id="player3">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
          <tr class="player" id="player4">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
          <tr class="player" id="player5">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
          <tr class="player" id="player6">
            <td>
              <div class="name"></div>
              <div class="champion-icon"></div>
              <div class="spell-icon" id="spell1"></div><div class="spell-icon" id="spell2"></div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
"""

update: (output, domEl) ->
  appData = @appData
  data = JSON.parse(output)
  getLoLData = @run
  $.each data, (index, element) ->
    appData["profileId"] = element.id

  @run("curl -s 'https://global.api.pvp.net/api/lol/static-data/na/#{appData["staticApiVersion"]}/realm?api_key=#{appData["apiKey"]}'",(error, output) ->
    data = JSON.parse(output)
    appData["ddragonApiVersion"] = data.dd
  )

  @run("curl -s 'https://#{appData["regionName"]}.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/#{appData['specialRegionName']}/#{appData["profileId"]}?api_key=#{appData["apiKey"]}'",(error, output) ->
    try
      data = JSON.parse(output)
      console.log("hi")
      participants = data.participants
      for playerNum in [1..participants.length/2]
        setup(playerNum, participants, 1)
        setup(playerNum, participants, 2)
        $(domEl).find('#team2').css("border-left-width", "1px")
        $(domEl).css("opacity", "1")
    catch
      $(domEl).find('#team2').css("border-left-width", "0px")
      $(domEl).css("opacity", "0")
  )

  setup = (playerNum, participants, teamNum) ->
    player = $(domEl).find("#team"+teamNum).find('#player'+playerNum)
    if teamNum == 2
      playerNum += participants.length/2
    name = participants[playerNum-1].summonerName
    if name.split(" ").length <= 1
      newName = name.substring(0, 11)+" "+ name.substring(11, 22)
    else
      newName = name
    player.find('.name').text(newName)
    getLoLData("curl -s 'https://global.api.pvp.net/api/lol/static-data/#{appData["regionName"]}/#{appData["staticApiVersion"]}/champion/"+participants[playerNum-1].championId+"?champData=image&api_key=#{appData["apiKey"]}'",(error, output) ->
      data = JSON.parse(output)
      player.find('.champion-icon').html("<img class='champion-icon' src='http://ddragon.leagueoflegends.com/cdn/#{appData["ddragonApiVersion"]}/img/champion/"+data.image.full+"' width='40px'>")
    )
    getLoLData("curl -s 'https://global.api.pvp.net/api/lol/static-data/#{appData["regionName"]}/#{appData["staticApiVersion"]}/summoner-spell/"+participants[playerNum-1].spell1Id+"?spellData=image&api_key=#{appData["apiKey"]}'",(error, output) ->
      data = JSON.parse(output)
      player.find('#spell1').html("<img class='spell-icon' id='spell1' src='http://ddragon.leagueoflegends.com/cdn/#{appData["ddragonApiVersion"]}/img/spell/"+data.image.full+"' width='20px'>")
    )
    getLoLData("curl -s 'https://global.api.pvp.net/api/lol/static-data/#{appData["regionName"]}/#{appData["staticApiVersion"]}/summoner-spell/"+participants[playerNum-1].spell2Id+"?spellData=image&api_key=#{appData["apiKey"]}'",(error, output) ->
      data = JSON.parse(output)
      player.find('#spell2').html("<img class='spell-icon' id='spell2' src='http://ddragon.leagueoflegends.com/cdn/#{appData["ddragonApiVersion"]}/img/spell/"+data.image.full+"' width='20px'>")
    )



appData:
  'apiKey': @apiKey
  'summonerApiVersion': @summonerApiVersion
  'ddragonApiVersion': @ddragonApiVersion
  'staticApiVersion': @staticApiVersion
  'regionName': @regionName
  'specialRegionName': @specialRegionName
  'summonerName': @summonerName
  'profileId': 'profile-id'
  'championId': 'champion-id'
