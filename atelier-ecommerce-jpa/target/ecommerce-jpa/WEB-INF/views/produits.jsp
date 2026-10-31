<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="produits"/>
<c:set var="pageEyebrow" value="CATALOGUE"/>
<c:set var="pageTitle" value="Produits"/>
<c:set var="pageDescription" value="Pilotez le catalogue, les prix et les quantités disponibles."/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>

<section class="metric-grid" aria-label="Indicateurs du catalogue">
    <article class="metric-card">
        <span class="metric-icon metric-icon-blue" aria-hidden="true">
            <svg viewBox="0 0 24 24"><path d="M4 7.5 12 3l8 4.5v9L12 21l-8-4.5z"/><path d="m4.5 7.8 7.5 4.3 7.5-4.3M12 12.1V21"/></svg>
        </span>
        <div><span class="metric-label">Références catalogue</span><strong class="metric-value"><c:out value="${produitsCount}"/></strong><span class="metric-note">Produits enregistrés</span></div>
    </article>
    <article class="metric-card">
        <span class="metric-icon metric-icon-cyan" aria-hidden="true">
            <svg viewBox="0 0 24 24"><path d="M4 7.5 12 3l8 4.5v9L12 21l-8-4.5z"/><path d="m4.5 7.8 7.5 4.3 7.5-4.3"/></svg>
        </span>
        <div><span class="metric-label">Unités en stock</span><strong class="metric-value"><c:out value="${stockTotal}"/></strong><span class="metric-note">Somme du stock des produits</span></div>
    </article>
    <article class="metric-card">
        <span class="metric-icon metric-icon-amber" aria-hidden="true">
            <svg viewBox="0 0 24 24"><path d="M12 3 2.8 19h18.4L12 3z"/><path d="M12 9v4M12 16.5v.1"/></svg>
        </span>
        <div><span class="metric-label">Références épuisées</span><strong class="metric-value"><c:out value="${produitsEpuises}"/></strong><span class="metric-note">Stock égal à zéro</span></div>
    </article>
</section>

<div class="content-grid products-layout">
    <section class="panel collection-panel" aria-labelledby="catalog-title">
        <div class="section-heading">
            <div>
                <p class="section-kicker">Catalogue en direct</p>
                <h2 id="catalog-title">Tous les produits</h2>
                <p class="section-description">Les informations affichées correspondent aux champs du modèle Produit.</p>
            </div>
            <span class="count-badge"><c:out value="${produitsCount}"/> articles</span>
        </div>

        <c:choose>
            <c:when test="${empty produits}">
                <div class="empty-state" id="products-empty">
                    <span class="empty-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24"><path d="M4 7.5 12 3l8 4.5v9L12 21l-8-4.5z"/><path d="M12 12v8.5M4.5 7.8 12 12l7.5-4.2M12 12v-5"/></svg>
                    </span>
                    <h3>Le catalogue est encore vide</h3>
                    <p>Créez une première référence avec son nom, son prix et son stock.</p>
                    <a class="button button-secondary" href="#product-form">Ajouter un produit</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="collection-toolbar">
                    <label class="search-field">
                        <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="10.8" cy="10.8" r="6.8"/><path d="m16 16 4.5 4.5"/></svg>
                        <span class="sr-only">Rechercher un produit</span>
                        <input type="search" placeholder="Rechercher un produit…" autocomplete="off"
                               data-live-search data-search-target="#product-grid">
                    </label>
                    <label class="filter-field">
                        <span class="sr-only">Filtrer par disponibilité</span>
                        <select data-stock-filter aria-label="Filtrer par disponibilité">
                            <option value="all">Tout le stock</option>
                            <option value="available">En stock</option>
                            <option value="empty">Épuisés</option>
                        </select>
                    </label>
                    <span class="result-count" data-search-count aria-live="polite"></span>
                </div>
                <div class="product-grid" id="product-grid">
                    <c:forEach items="${produits}" var="p">
                        <article class="product-card" data-search-item
                                 data-search-text="<c:out value='${p.id} ${p.nom} ${p.description}'/>"
                                 data-stock="${p.stock}">
                            <div class="product-card-top">
                                <span class="product-symbol" aria-hidden="true">
                                    <svg viewBox="0 0 24 24"><path d="M4 7.5 12 3l8 4.5v9L12 21l-8-4.5z"/><path d="m4.5 7.8 7.5 4.3 7.5-4.3M12 12.1V21"/></svg>
                                </span>
                                <span class="id-chip">Réf. #<c:out value="${p.id}"/></span>
                                <span class="badge ${p.stock > 0 ? 'badge-success' : 'badge-danger'}">
                                    <span class="badge-dot"></span>
                                    <c:choose><c:when test="${p.stock > 0}">Disponible</c:when><c:otherwise>Épuisé</c:otherwise></c:choose>
                                </span>
                            </div>
                            <div class="product-card-copy">
                                <h3><c:out value="${p.nom}"/></h3>
                                <p><c:choose><c:when test="${not empty p.description}"><c:out value="${p.description}"/></c:when><c:otherwise><span class="muted-italic">Aucune description renseignée.</span></c:otherwise></c:choose></p>
                            </div>
                            <div class="product-card-data">
                                <div><span>Prix unitaire</span><strong><fmt:formatNumber value="${p.prix}" minFractionDigits="2" maxFractionDigits="2"/> <abbr title="Dirham">DH</abbr></strong></div>
                                <div><span>Stock</span><strong><c:out value="${p.stock}"/> <small>unités</small></strong></div>
                            </div>
                            <div class="product-card-actions">
                                <form method="post" action="${pageContext.request.contextPath}/panier" class="add-to-cart-form">
                                    <input type="hidden" name="action" value="ajouter">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button class="button button-primary button-add" type="submit" ${p.stock <= 0 ? 'disabled' : ''}>
                                        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 4h2l2.2 10.2a2 2 0 0 0 2 1.6h8a2 2 0 0 0 1.9-1.4L21 8H6"/><circle cx="10" cy="19" r="1.3"/><circle cx="18" cy="19" r="1.3"/></svg>
                                        <c:choose><c:when test="${p.stock > 0}">Ajouter au panier</c:when><c:otherwise>Indisponible</c:otherwise></c:choose>
                                    </button>
                                </form>
                                <a class="icon-button" href="${pageContext.request.contextPath}/produits?action=editer&amp;id=${p.id}" aria-label="Modifier le produit">
                                    <svg viewBox="0 0 24 24" aria-hidden="true"><path d="m14 5 5 5M4 20l4.2-.8L19 8.4 15.6 5 4.8 15.8z"/></svg>
                                </a>
                                <form class="inline-form" method="post" action="${pageContext.request.contextPath}/produits"
                                      data-confirm="Supprimer ce produit ? Cette action ne pourra pas être annulée.">
                                    <input type="hidden" name="action" value="supprimer">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button class="icon-button danger-button" type="submit" aria-label="Supprimer le produit">
                                        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/></svg>
                                    </button>
                                </form>
                            </div>
                        </article>
                    </c:forEach>
                </div>
                <p class="filter-empty" data-filter-empty hidden>Aucun produit ne correspond aux filtres sélectionnés.</p>
            </c:otherwise>
        </c:choose>
    </section>

    <aside class="panel form-panel" id="product-form" aria-labelledby="product-form-title">
        <div class="form-panel-heading">
            <span class="form-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><path d="M4 7.5 12 3l8 4.5v9L12 21l-8-4.5z"/><path d="M12 12v9M12 12l7.5-4.2M12 12 4.5 7.8M12 8v8M8 12h8"/></svg>
            </span>
            <div>
                <p class="section-kicker"><c:choose><c:when test="${not empty edit}">MISE À JOUR</c:when><c:otherwise>NOUVELLE RÉFÉRENCE</c:otherwise></c:choose></p>
                <h2 id="product-form-title"><c:choose><c:when test="${not empty edit}">Modifier le produit</c:when><c:otherwise>Ajouter un produit</c:otherwise></c:choose></h2>
            </div>
        </div>
        <p class="form-intro">Définissez les informations de catalogue et de stock de cet article.</p>
        <form method="post" action="${pageContext.request.contextPath}/produits" class="stacked-form">
            <input type="hidden" name="action" value="${empty edit ? 'ajouter' : 'modifier'}">
            <c:if test="${not empty edit}"><input type="hidden" name="id" value="${edit.id}"></c:if>
            <div class="field">
                <label for="product-name">Nom du produit <span class="required-mark">*</span></label>
                <input id="product-name" name="nom" type="text" value="<c:out value='${edit.nom}'/>" required maxlength="160" placeholder="Ex. Sac en cuir">
            </div>
            <div class="field">
                <label for="product-description">Description</label>
                <textarea id="product-description" name="description" rows="3" maxlength="2000" placeholder="Décrivez brièvement le produit"><c:out value="${edit.description}"/></textarea>
            </div>
            <div class="field-row">
                <div class="field">
                    <label for="product-price">Prix (DH) <span class="required-mark">*</span></label>
                    <div class="input-with-suffix">
                        <input id="product-price" name="prix" type="number" step="0.01" min="0" value="${edit.prix}" required inputmode="decimal" placeholder="0,00">
                        <span>DH</span>
                    </div>
                </div>
                <div class="field">
                    <label for="product-stock">Stock <span class="required-mark">*</span></label>
                    <div class="input-with-suffix">
                        <input id="product-stock" name="stock" type="number" step="1" min="0" value="${edit.stock}" required inputmode="numeric" placeholder="0">
                        <span>unités</span>
                    </div>
                </div>
            </div>
            <div class="form-actions">
                <button class="button button-primary button-full" type="submit">
                    <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                    <c:choose><c:when test="${not empty edit}">Enregistrer les modifications</c:when><c:otherwise>Créer la référence</c:otherwise></c:choose>
                </button>
                <c:if test="${not empty edit}">
                    <a class="button button-quiet button-full" href="${pageContext.request.contextPath}/produits">Annuler la modification</a>
                </c:if>
            </div>
        </form>
        <div class="form-footnote"><span class="required-mark">*</span> Champs obligatoires</div>
    </aside>
</div>

<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>