function addToggleListerner(sel_id, menu_id, toggle_class){
  let selectedItem = document.querySelector(`#${sel_id}`);
  selectedItem.addEventListener("click", function(e){
    e.preventDefault();
    let menu = document.querySelector(`#${menu_id}`);
    menu.classList.toggle(`${toggle_class}`)
  })
}
document.addEventListener("turbo:load", function(){
  addToggleListerner("hamburger", "navbar-menu", "collapse")
  addToggleListerner("account", "dropdown-menu", "active")
})

