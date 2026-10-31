<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="commandes"/>
<c:set var="pageEyebrow" value="SUIVI DES VENTES"/>
<c:set var="pageTitle" value="Commandes"/>
<c:set var="pageDescription" value="Consultez les commandes validées, leur client et le détail des articles."/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>

<section class="panel collection-panel orders-panel" aria-labelledby="orders-title">
    <div class="section-heading">
        <div>
            <p class="section-kicker">Historique métier</p>
            <h2 id="orders-title">Toutes les commandes</h2>
            <p class="section-description">Les lignes et montants sont calculés à partir des données de commande enregistrées.</p>
        </div>
        <span class="count-badge"><c:out value="${commandes.size()}"/> commandes</span>
    </div>

    <c:choose>
        <c:when test="${empty commandes}">
            <div class="empty-state">
                <span class="empty-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24"><path d="M5 4h14v16H5zM8 8h8M8 12h8M8 16h5"/></svg>
                </span>
                <h3>Aucune commande pour le moment</h3>
                <p>Les commandes validées depuis le panier apparaîtront ici.</p>
                <a class="button button-secondary" href="${pageContext.request.contextPath}/produits">Voir le catalogue</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="collection-toolbar">
                <label class="search-field">
                    <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="10.8" cy="10.8" r="6.8"/><path d="m16 16 4.5 4.5"/></svg>
                    <span class="sr-only">Rechercher dans les commandes</span>
                    <input type="search" placeholder="Rechercher par numéro, client ou statut…" autocomplete="off"
                           data-live-search data-search-target="#orders-list">
                </label>
                <span class="result-count" data-search-count aria-live="polite"></span>
            </div>
            <div class="orders-list" id="orders-list">
                <c:forEach items="${commandes}" var="commande">
                    <c:set var="orderTotal" value="${0.0}"/>
                    <article class="order-card" data-search-item
                             data-search-text="<c:out value='${commande.id} ${commande.client.nom} ${commande.statut}'/>">
                        <header class="order-card-header">
                            <div class="order-title-wrap">
                                <span class="order-mark" aria-hidden="true">
                                    <svg viewBox="0 0 24 24"><path d="M5 4h14v16H5zM8 8h8M8 12h8M8 16h5"/></svg>
                                </span>
                                <div><p class="section-kicker">COMMANDE</p><h3>#<c:out value="${commande.id}"/></h3></div>
                            </div>
                            <span class="badge ${commande.statut == 'VALIDEE' ? 'badge-success' : 'badge-neutral'}">
                                <span class="badge-dot"></span><c:out value="${commande.statut}"/>
                            </span>
                        </header>
                        <div class="order-meta">
                            <div><span>Client</span><strong><c:out value="${commande.client.nom}"/></strong></div>
                            <div><span>Date</span><strong><c:out value="${commande.dateCommande}"/></strong></div>
                            <div><span>Référence client</span><strong>#<c:out value="${commande.client.id}"/></strong></div>
                        </div>
                        <div class="table-wrap">
                            <table class="data-table order-lines-table">
                                <thead><tr><th scope="col">Produit</th><th scope="col">Prix unitaire</th><th scope="col">Quantité</th><th scope="col" class="align-right">Sous-total</th></tr></thead>
                                <tbody>
                                <c:forEach items="${commande.lignes}" var="ligne">
                                    <c:set var="orderTotal" value="${orderTotal + (ligne.quantite * ligne.prixUnitaire)}"/>
                                    <tr>
                                        <td><strong><c:out value="${ligne.produit.nom}"/></strong></td>
                                        <td><fmt:formatNumber value="${ligne.prixUnitaire}" minFractionDigits="2" maxFractionDigits="2"/> DH</td>
                                        <td><c:out value="${ligne.quantite}"/></td>
                                        <td class="align-right"><strong><fmt:formatNumber value="${ligne.quantite * ligne.prixUnitaire}" minFractionDigits="2" maxFractionDigits="2"/> DH</strong></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                                <tfoot><tr><td colspan="3">Total commande</td><td class="align-right"><strong><fmt:formatNumber value="${orderTotal}" minFractionDigits="2" maxFractionDigits="2"/> DH</strong></td></tr></tfoot>
                            </table>
                        </div>
                    </article>
                </c:forEach>
            </div>
            <p class="filter-empty" data-filter-empty hidden>Aucune commande ne correspond à cette recherche.</p>
        </c:otherwise>
    </c:choose>
</section>

<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>