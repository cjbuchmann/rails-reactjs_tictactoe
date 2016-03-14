# rails-reactjs_tictactoe
Tic Tac Toe using ReactJS in Rails Environment with a simple Rails backed API

![alt tag](https://github.com/cjbuchmann/rails-reactjs_tictactoe/blob/master/app/assets/images/screenshot.png?raw=true)

# React JS
This project uses the React-Rails gem. As such, the components are stored under
```
/app/assets/javascript/components
```

# Tic Tac Toe API
As the focus of this project is on the UI rather than the API, this project uses only a simple session bases API.

The following endpoints are available

## Create Board
POST : /api/v1/board

Request Example : 
```json
{
    "board":{
        "size":3,
        "player_one": "X",
        "player_two": "O"
    }
}
```

## Get Board
GET : /api/v1/board

Response Example :
```json
{
  "board": [
    [
      null,
      null,
      null
    ],
    [
      {
        "x_pos": 1,
        "y_pos": 0,
        "player": "X"
      },
      null,
      null
    ],
    [
      null,
      null,
      null
    ]
  ],
  "player_one": "X",
  "player_two": "O",
  "current_player_turn": "O",
  "winner": null
}
```

## Add a Move
POST : /api/v1/board/move

Request Example :
```json
{
  "move":{
    "x_pos": 1,
    "y_pos": 1,
    "player": "X"
  }
}
```
