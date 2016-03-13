
var NewGame = React.createClass({
  getInitialState: function(){
    return { board_size: 3 }
  },

  handleSubmit: function(e){
    e.preventDefault();
    var board = { size: this.state.board_size };
    this.props.onNewGame({ board: board });
  },

  handleBoardSizeChange: function(e){
    this.setState({ board_size: e.target.value });
  },

  render: function(){
    return (
      <div className='new-game-container'>
        Board Size:
        <input type="text" className='new-game-input' onChange={ this.handleBoardSizeChange } value={ this.state.board_size } />
        <button onClick={this.handleSubmit}>Start a new game</button>
      </div>
    );
  }
});

var TicCols = React.createClass({
  render: function(){
    var tableCols = this.props.cols.map(function(item, index){
      return (
        <td>{propKey},{ index }</td>
      )
    });

    return (
      <tr key={propKey}>
        {tableCols}
      </tr>
    );
  }
})

var Board = React.createClass({
  handleAddMove: function(e){
    var move = {
      x_pos: $(e.target).data('row'),
      y_pos: $(e.target).data('col'),
      player: this.props.currentPlayer
    };

    this.props.onNewMove({ move: move });
  },

  render: function(){
    var _this = this;

    var tableRows = this.props.board.map(function(row, i){
      return (
        <tr key={i}>
          {
            row.map(function(col, j){
              return (
                <td key={i+':'+j} data-row={i} data-col={j} onClick={ _this.handleAddMove }>{ col ? col.player : ''}</td>
              )
            })
          }
        </tr>
      )
    });

    return (
      <table className='tic-tac-toe-table'>
        <tbody>
          {tableRows}
        </tbody>
      </table>
    );
  }
});

var TicTacToe = React.createClass({
  getInitialState: function(){
    return { board: [], player: 'X', winner: null }
  },

  nextPlayer: function(){
    if(this.state.player === 'X'){
      return 'O';
    }
    return 'X';
  },

  componentDidMount: function(){
    // try to load an existing game
    $.ajax({
      url: this.props.gameUrl,
      dataType: 'json',
      type: 'GET',
      success: function(data){
        this.setState({
          board: data.board,
          winner: data.winner
        });
      }.bind(this)
    });
  },

  handleNewGame: function(board){
    $.ajax({
      url: this.props.gameUrl,
      dataType: 'json',
      type: 'POST',
      data: board,
      success: function(data){
        this.setState({
          board: data.board,
          player: 'X',
          winner: data.winner
        });
      }.bind(this)
    });
  },

  handleNewMove: function(move){
    if( this.state.winner ){
      return;
    }

    $.ajax({
      url: this.props.moveUrl,
      dataType: 'json',
      type: 'POST',
      data: move,
      success: function(data){
        var board = this.state.board;
        board[data.move.x_pos][data.move.y_pos] = data.move;
        this.setState({
          board: board,
          player: this.nextPlayer(),
          winner: data.winner
        });
      }.bind(this)
    })
  },

  render: function(){
    var winnerElement = null;
    if(this.state.winner){
      winnerElement = <div className='winner-container'>{this.state.winner} has won!</div>
    }

    return (
      <div className='tic-tac-toe'>
        <NewGame onNewGame={ this.handleNewGame } />
        {winnerElement}
        <Board onNewMove={ this.handleNewMove } board={ this.state.board } currentPlayer={ this.state.player } />
      </div>
    );
  }
});
