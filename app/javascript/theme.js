function applyTheme(theme) {
  document.documentElement.setAttribute("data-theme", theme);
  localStorage.setItem("theme", theme);

  const button = document.getElementById("theme-toggle");

  if (button) {
    const icon = button.querySelector("i");
    const label = button.querySelector("span");

    if (icon) {
      icon.className =
        theme === "dark" ? "bi bi-sun-fill" : "bi bi-moon-stars-fill";
    }

    if (label) {
      label.textContent = theme === "dark" ? "Light Mode" : "Night Mode";
    }
  }
}

function initializeThemeToggle() {
  const button = document.getElementById("theme-toggle");

  if (!button || button.dataset.initialized === "true") return;

  button.dataset.initialized = "true";

  applyTheme(localStorage.getItem("theme") || "light");

  button.addEventListener("click", function () {
    const currentTheme = document.documentElement.getAttribute("data-theme");
    applyTheme(currentTheme === "dark" ? "light" : "dark");
  });
}

document.addEventListener("turbo:load", initializeThemeToggle);
document.addEventListener("DOMContentLoaded", initializeThemeToggle);