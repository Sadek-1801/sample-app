function addToggleListerner(selectedId, menuId, toggleClass){
  let selectedItem = document.querySelector(`#${selectedId}`);
  selectedItem.addEventListener("click", function(e){
    e.preventDefault();
    let menu = document.querySelector(`#${menuId}`);
    menu.classList.toggle(`${toggleClass}`)
  })
}
document.addEventListener("turbo:load", function(){
  addToggleListerner("hamburger", "navbar-menu", "collapse")
  addToggleListerner("account", "dropdown-menu", "active")
})

