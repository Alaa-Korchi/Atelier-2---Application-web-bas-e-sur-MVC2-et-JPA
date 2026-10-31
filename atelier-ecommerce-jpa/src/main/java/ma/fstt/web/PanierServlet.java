package ma.fstt.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ma.fstt.dao.ClientDAO;
import ma.fstt.dao.CommandeDAO;
import ma.fstt.dao.ProduitDAO;
import ma.fstt.model.Produit;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/panier")
public class PanierServlet extends HttpServlet {
    private final ProduitDAO produitDAO = new ProduitDAO();
    private final ClientDAO clientDAO = new ClientDAO();
    private final CommandeDAO commandeDAO = new CommandeDAO();

    @SuppressWarnings("unchecked")
    private Map<Long, Integer> cart(HttpSession session) {
        Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("panier");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("panier", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<Long, Integer> cart = cart(request.getSession());
        List<Produit> articles = new ArrayList<>();
        double total = 0;
        int quantiteTotale = 0;

        for (Map.Entry<Long, Integer> entry : cart.entrySet()) {
            Produit produit = produitDAO.trouver(entry.getKey());
            if (produit != null) {
                articles.add(produit);
                total += produit.getPrix() * entry.getValue();
                quantiteTotale += entry.getValue();
            }
        }

        request.setAttribute("articles", articles);
        request.setAttribute("quantites", cart);
        request.setAttribute("total", total);
        request.setAttribute("quantiteTotale", quantiteTotale);
        request.setAttribute("clients", clientDAO.tous());
        request.getRequestDispatcher("/WEB-INF/views/panier.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Map<Long, Integer> cart = cart(session);
        String action = request.getParameter("action");

        try {
            if ("ajouter".equals(action)) {
                Long id = Long.valueOf(request.getParameter("id"));
                cart.merge(id, 1, Integer::sum);
                session.setAttribute("message", "Produit ajouté au panier.");
            } else if ("retirer".equals(action)) {
                cart.remove(Long.valueOf(request.getParameter("id")));
                session.setAttribute("message", "Article retiré du panier.");
            } else if ("qte".equals(action)) {
                Long id = Long.valueOf(request.getParameter("id"));
                int quantite = Integer.parseInt(request.getParameter("q"));
                if (quantite <= 0) {
                    cart.remove(id);
                    session.setAttribute("message", "Article retiré du panier.");
                } else {
                    cart.put(id, quantite);
                    session.setAttribute("message", "Quantité mise à jour.");
                }
            } else if ("commander".equals(action)) {
                commandeDAO.valider(Long.valueOf(request.getParameter("clientId")), cart);
                cart.clear();
                session.setAttribute("message", "Commande validée.");
            } else {
                throw new IllegalArgumentException("Action inconnue.");
            }
        } catch (Exception exception) {
            session.setAttribute(
                    "erreur",
                    exception.getMessage() == null
                            ? "L'opération n'a pas pu aboutir."
                            : exception.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/panier");
    }
}