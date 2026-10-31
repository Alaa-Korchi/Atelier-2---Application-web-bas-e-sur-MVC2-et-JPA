(() => {
    const body = document.body;

    document.querySelectorAll("[data-sidebar-open]").forEach((button) => {
        button.addEventListener("click", () => {
            body.classList.add("nav-open");
            const firstLink = document.querySelector(".primary-nav a");
            if (firstLink) firstLink.focus({ preventScroll: true });
        });
    });

    document.querySelectorAll("[data-sidebar-close]").forEach((button) => {
        button.addEventListener("click", () => {
            body.classList.remove("nav-open");
            const opener = document.querySelector("[data-sidebar-open]");
            if (opener) opener.focus({ preventScroll: true });
        });
    });

    document.addEventListener("keydown", (event) => {
        if (event.key === "Escape" && body.classList.contains("nav-open")) {
            body.classList.remove("nav-open");
            const opener = document.querySelector("[data-sidebar-open]");
            if (opener) opener.focus({ preventScroll: true });
        }
    });

    document.querySelectorAll("form[data-confirm]").forEach((form) => {
        form.addEventListener("submit", (event) => {
            if (!window.confirm(form.dataset.confirm || "Confirmer cette action ?")) {
                event.preventDefault();
            }
        });
    });

    const normalize = (value) => (value || "")
        .toLocaleLowerCase("fr")
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .trim();

    document.querySelectorAll("[data-live-search]").forEach((input) => {
        const root = input.closest(".collection-panel");
        const target = document.querySelector(input.dataset.searchTarget || "");
        if (!root || !target) return;

        const items = Array.from(target.querySelectorAll("[data-search-item]"));
        const count = root.querySelector("[data-search-count]");
        const empty = root.querySelector("[data-filter-empty]");
        const stockFilter = root.querySelector("[data-stock-filter]");

        const update = () => {
            const query = normalize(input.value);
            const availability = stockFilter ? stockFilter.value : "all";
            let visible = 0;

            items.forEach((item) => {
                const text = normalize(item.dataset.searchText || item.textContent);
                const stock = Number(item.dataset.stock || 0);
                const matchesText = !query || text.includes(query);
                const matchesStock = availability === "all"
                    || (availability === "available" && stock > 0)
                    || (availability === "empty" && stock <= 0);
                const show = matchesText && matchesStock;
                item.hidden = !show;
                if (show) visible += 1;
            });

            if (count) count.textContent = `${visible} résultat${visible === 1 ? "" : "s"}`;
            if (empty) empty.hidden = visible !== 0;
        };

        input.addEventListener("input", update);
        if (stockFilter) stockFilter.addEventListener("change", update);
        update();
    });

    document.querySelectorAll("form:not([data-confirm])").forEach((form) => {
        form.addEventListener("submit", () => {
            const button = form.querySelector('button[type="submit"], button:not([type])');
            if (!button || button.disabled) return;
            button.disabled = true;
            button.classList.add("is-loading");
            button.setAttribute("aria-busy", "true");
        });
    });
})();
