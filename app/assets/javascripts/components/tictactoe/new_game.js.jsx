// UI for creating new Tic Tac Toe board
TicTacToe.NewGame = React.createClass({
  getInitialState: function(){
    return { board_size: 3 }
  },

  handleSubmit: function(e){
    e.preventDefault();
    var board = { size: this.state.board_size };
    this.props.onNewGame(board);
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
