function selectedTracks() {
  return Array.prototype.map.call(
    document.querySelectorAll("input[type=checkbox].track:checked"),
    function(item) {
      return item.id;
    });
}

function toggleAll(checkbox) {
  Array.prototype.forEach.call(
    document.querySelectorAll("input[type=checkbox].track"),
    function(item) {
      item.checked = checkbox.checked;
    });
}

function removeSelected() {
  var path, message, tracks = selectedTracks();
  message = "Are you sure you want to remove this " +
  tracks.length + "tracks?";
  if (confirm(message)) {
    $.ajax({
      url: document.location.pathname + '/remove',
      type: 'DELETE',
      data: {
        tracks: tracks
      },
      success: function(result) {
        document.location.reload();
      }
    });
  }
}

(function() {
  document.querySelector("input[type=checkbox].all")
    .addEventListener("change", function() { toggleAll(this); });
  document.querySelector("button#remove")
    .addEventListener("click", function() { removeSelected(); });
})();
