<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="panier"/>
<c:set var="pageEyebrow" value="PRÉPARATION DE COMMANDE"/>
<c:set var="pageTitle" value="Panier"/>
<c:set var="pageDescription" value="Vérifiez les articles, ajustez les quantités et associez la commande à un client."/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>

<c:choose>
    <c:when test="${empty articles}">
        <section class="panel empty-cart">
            <span class="empty-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><path d="M3 4h2l2.2 10.2a2 2 0 0 0 2 1.6h8a2 2 0 0 0 1.9-1.4L21 8H6"/><circle cx="10" cy="19" r="1.3"/><circle cx="18" cy="19" r="1.3"/></svg>
            </span>
            <p class="section-kicker">VOTRE SÉLECTION</p>
            <h2>Votre panier est vide</h2>
            <p>Parcourez le catalogue et ajoutez les produits à commander.</p>
            <a class="button button-primary" href="${pageContext.request.contextPath}/produits">
                Voir les produits
                <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
            </a>
        </section>
    </c:when>
    <c:otherwise>
        <div class="cart-layout">
            <section class="panel collection-panel" aria-labelledby="cart-items-title">
                <div class="section-heading">
                    <div>
                        <p class="section-kicker">SÉLECTION EN COURS</p>
                        <h2 id="cart-items-title">Articles à commander</h2>
                        <p class="section-description"><c:out value="${quantiteTotale}"/> unité(s) répartie(s) sur <c:out value="${articles.size()}"/> référence(s).</p>
                    </div>
                    <a class="button button-quiet" href="${pageContext.request.contextPath}/produits">Continuer le catalogue</a>
                </div>
                <div class="table-wrap">
                    <table class="data-table cart-table">
                        <thead>
                        <tr><th scope="col">Produit</th><th scope="col">Prix unitaire</th><th scope="col">Quantité</th><th scope="col">Sous-total</th><th scope="col"><span class="sr-only">Actions</span></th></tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${articles}" var="p">
                            <tr>
                                <td>
                                    <div class="person-cell">
                                        <span class="product-symbol product-symbol-small" aria-hidden="true">
                                            <svg viewBox="0 0 24 24"><path d="M4 7.5 12 3l8 4.5v9L12 21l-8-4.5z"/><path d="m4.5 7.8 7.5 4.3 7.5-4.3M12 12.1V21"/></svg>
                                        </span>
                                        <span class="person-name"><strong><c:out value="${p.nom}"/></strong><small>Référence #<c:out value="${p.id}"/></small></span>
                                    </div>
                                </td>
                                <td><strong class="price-value"><fmt:formatNumber value="${p.prix}" minFractionDigits="2" maxFractionDigits="2"/> DH</strong></td>
                                <td>
                                    <form class="quantity-form" method="post" action="${pageContext.request.contextPath}/panier">
                                        <input type="hidden" name="action" value="qte">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <label class="sr-only" for="quantity-${p.id}">Quantité pour <c:out value="${p.nom}"/></label>
                                        <input id="quantity-${p.id}" name="q" type="number" min="0" step="1" inputmode="numeric" value="${quantites[p.id]}" aria-label="Quantité">
                                        <button class="button button-secondary button-compact" type="submit">Mettre à jour</button>
                                    </form>
                                </td>
                                <td><strong class="price-value"><fmt:formatNumber value="${p.prix * quantites[p.id]}" minFractionDigits="2" maxFractionDigits="2"/> DH</strong></td>
                                <td class="align-right">
                                    <form class="inline-form" method="post" action="${pageContext.request.contextPath}/panier">
                                        <input type="hidden" name="action" value="retirer">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <button class="icon-button danger-button" type="submit" aria-label="Retirer le produit du panier">
                                            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/></svg>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <p class="cart-footnote">La disponibilité du stock est vérifiée à la validation de la commande.</p>
            </section>

            <aside class="panel checkout-panel" aria-labelledby="checkout-title">
                <p class="section-kicker">RÉCAPITULATIF</p>
                <h2 id="checkout-title">Finaliser la commande</h2>
                <div class="summary-line"><span>Nombre d’articles</span><strong><c:out value="${quantiteTotale}"/></strong></div>
                <div class="summary-line"><span>Références</span><strong><c:out value="${articles.size()}"/></strong></div>
                <div class="summary-total"><span>Total estimé</span><strong><fmt:formatNumber value="${total}" minFractionDigits="2" maxFractionDigits="2"/> <abbr title="Dirham">DH</abbr></strong></div>
                <p class="summary-note">Le total définitif dépend des prix enregistrés au moment de la validation.</p>

                <c:choose>
                    <c:when test="${empty clients}">
                        <div class="inline-notice" role="status">
                            <strong>Aucun client disponible</strong>
                            <span>Créez un client avant de valider cette commande.</span>
                        </div>
                        <a class="button button-primary button-full" href="${pageContext.request.contextPath}/clients">Ajouter un client</a>
                    </c:when>
                    <c:otherwise>
                        <form method="post" action="${pageContext.request.contextPath}/panier" class="stacked-form checkout-form">
                            <input type="hidden" name="action" value="commander">
                            <div class="field">
                                <label for="order-client">Client associé <span class="required-mark">*</span></label>
                                <select id="order-client" name="clientId" required>
                                    <option value="">Sélectionner un client</option>
                                    <c:forEach items="${clients}" var="client">
                                        <option value="${client.id}"><c:out value="${client.nom}"/> · #<c:out value="${client.id}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <button class="button button-primary button-full" type="submit">
                                Valider la commande
                                <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </aside>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>