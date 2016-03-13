// Main Tic Tac Toe logic and coordinator
TicTacToe.Game = React.createClass({
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
        <TicTacToe.NewGame onNewGame={ this.handleNewGame } />
        {winnerElement}
        <TicTacToe.Board onNewMove={ this.handleNewMove } board={ this.state.board } currentPlayer={ this.state.player } />
      </div>
    );
  }
});
