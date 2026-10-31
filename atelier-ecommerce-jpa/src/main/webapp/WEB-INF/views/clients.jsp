<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activePage" value="clients"/>
<c:set var="pageEyebrow" value="RELATION CLIENT"/>
<c:set var="pageTitle" value="Clients"/>
<c:set var="pageDescription" value="Retrouvez les contacts enregistrés et gérez leurs informations."/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>

<div class="content-grid clients-layout">
    <section class="panel collection-panel" aria-labelledby="clients-list-title">
        <div class="section-heading">
            <div>
                <p class="section-kicker">Répertoire</p>
                <h2 id="clients-list-title">Tous les clients</h2>
                <p class="section-description">Les coordonnées proviennent de la base de données du projet.</p>
            </div>
            <span class="count-badge"><c:out value="${clientsCount}"/> <c:choose><c:when test="${clientsCount == 1}">client</c:when><c:otherwise>clients</c:otherwise></c:choose></span>
        </div>

        <c:choose>
            <c:when test="${empty clients}">
                <div class="empty-state" id="clients-empty">
                    <span class="empty-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24"><circle cx="9" cy="8" r="3.5"/><path d="M3 20v-1.5A4.5 4.5 0 0 1 7.5 14h3a4.5 4.5 0 0 1 4.5 4.5V20M17 8h4M19 6v4"/></svg>
                    </span>
                    <h3>Aucun client enregistré</h3>
                    <p>Ajoutez un client pour pouvoir associer une commande à un contact.</p>
                    <a class="button button-secondary" href="#client-form">Créer un client</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="collection-toolbar">
                    <label class="search-field">
                        <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="10.8" cy="10.8" r="6.8"/><path d="m16 16 4.5 4.5"/></svg>
                        <span class="sr-only">Rechercher un client</span>
                        <input type="search" placeholder="Rechercher par nom, e-mail ou ID…" autocomplete="off"
                               data-live-search data-search-target="#client-rows">
                    </label>
                    <span class="result-count" data-search-count aria-live="polite"></span>
                </div>
                <div class="table-wrap">
                    <table class="data-table">
                        <thead>
                        <tr><th scope="col">Client</th><th scope="col">E-mail</th><th scope="col">Identifiant</th><th scope="col" class="align-right">Actions</th></tr>
                        </thead>
                        <tbody id="client-rows">
                        <c:forEach items="${clients}" var="client">
                            <tr data-search-item data-search-text="<c:out value='${client.id} ${client.nom} ${client.email}'/>">
                                <td>
                                    <div class="person-cell">
                                        <span class="avatar" aria-hidden="true">
                                            <svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="3.5"/><path d="M5 20v-1.5A4.5 4.5 0 0 1 9.5 14h5a4.5 4.5 0 0 1 4.5 4.5V20"/></svg>
                                        </span>
                                        <span class="person-name"><strong><c:out value="${client.nom}"/></strong><small>Client enregistré</small></span>
                                    </div>
                                </td>
                                <td><a class="email-link" href="mailto:<c:out value='${client.email}'/>"><c:out value="${client.email}"/></a></td>
                                <td><span class="id-chip">#<c:out value="${client.id}"/></span></td>
                                <td class="align-right">
                                    <div class="row-actions">
                                        <a class="icon-button" href="${pageContext.request.contextPath}/clients?action=editer&amp;id=${client.id}" aria-label="Modifier le client">
                                            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="m14 5 5 5M4 20l4.2-.8L19 8.4 15.6 5 4.8 15.8z"/></svg>
                                        </a>
                                        <form class="inline-form" method="post" action="${pageContext.request.contextPath}/clients"
                                              data-confirm="Supprimer ce client ? Cette action ne pourra pas être annulée.">
                                            <input type="hidden" name="action" value="supprimer">
                                            <input type="hidden" name="id" value="${client.id}">
                                            <button class="icon-button danger-button" type="submit" aria-label="Supprimer le client">
                                                <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/></svg>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <p class="filter-empty" data-filter-empty hidden>Aucun client ne correspond à cette recherche.</p>
            </c:otherwise>
        </c:choose>
    </section>

    <aside class="panel form-panel" id="client-form" aria-labelledby="client-form-title">
        <div class="form-panel-heading">
            <span class="form-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><circle cx="9" cy="8" r="3.5"/><path d="M3 20v-1.5A4.5 4.5 0 0 1 7.5 14h3a4.5 4.5 0 0 1 4.5 4.5V20M18 8v6M15 11h6"/></svg>
            </span>
            <div>
                <p class="section-kicker"><c:choose><c:when test="${not empty edit}">MISE À JOUR</c:when><c:otherwise>NOUVEAU CONTACT</c:otherwise></c:choose></p>
                <h2 id="client-form-title"><c:choose><c:when test="${not empty edit}">Modifier le client</c:when><c:otherwise>Ajouter un client</c:otherwise></c:choose></h2>
            </div>
        </div>
        <p class="form-intro">Renseignez les coordonnées utilisées pour associer les commandes au bon contact.</p>
        <form method="post" action="${pageContext.request.contextPath}/clients" class="stacked-form">
            <input type="hidden" name="action" value="${empty edit ? 'ajouter' : 'modifier'}">
            <c:if test="${not empty edit}"><input type="hidden" name="id" value="${edit.id}"></c:if>
            <div class="field">
                <label for="client-name">Nom complet <span class="required-mark">*</span></label>
                <input id="client-name" name="nom" type="text" value="<c:out value='${edit.nom}'/>" autocomplete="name" required maxlength="120" placeholder="Ex. Samira El Amrani">
            </div>
            <div class="field">
                <label for="client-email">Adresse e-mail <span class="required-mark">*</span></label>
                <input id="client-email" name="email" type="email" value="<c:out value='${edit.email}'/>" autocomplete="email" required maxlength="254" placeholder="nom@exemple.com">
                <span class="field-hint">L’adresse e-mail doit être unique.</span>
            </div>
            <div class="form-actions">
                <button class="button button-primary button-full" type="submit">
                    <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                    <c:choose><c:when test="${not empty edit}">Enregistrer les modifications</c:when><c:otherwise>Créer le client</c:otherwise></c:choose>
                </button>
                <c:if test="${not empty edit}">
                    <a class="button button-quiet button-full" href="${pageContext.request.contextPath}/clients">Annuler la modification</a>
                </c:if>
            </div>
        </form>
        <div class="form-footnote"><span class="required-mark">*</span> Champs obligatoires</div>
    </aside>
</div>

<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>