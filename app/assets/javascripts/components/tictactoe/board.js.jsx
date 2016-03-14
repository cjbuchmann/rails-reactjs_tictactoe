// Primary TicTacToe board state. Manages board positions, and
// handles board interactions
TicTacToe.Board = React.createClass({
  handleAddMove: function(e){
    var move = {
      x_pos: $(e.target).data('row'),
      y_pos: $(e.target).data('col'),
      player: this.props.currentPlayer
    };

    this.props.onNewMove(move);
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
