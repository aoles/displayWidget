HTMLWidgets.widget({

  name: 'displayWidget',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    var viewer = new Viewer(el.id);

    return {

      renderValue: function(x) {
        viewer.init(x.data, x.width, x.height);
      },

      resize: function(width, height) {
        viewer.resetCanvas();
        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
