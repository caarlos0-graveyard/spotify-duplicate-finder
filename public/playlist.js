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

(function() {
  document
    .querySelector("input[type=checkbox].all")
    .addEventListener("change", function() {
      toggleAll(this);
    });
})();
