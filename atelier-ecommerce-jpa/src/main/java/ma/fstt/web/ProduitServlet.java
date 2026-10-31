package ma.fstt.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ma.fstt.dao.ProduitDAO;
import ma.fstt.model.Produit;

import java.io.IOException;
import java.util.List;

@WebServlet("/produits")
public class ProduitServlet extends HttpServlet {
    private final ProduitDAO dao = new ProduitDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("editer".equals(request.getParameter("action"))) {
            try {
                Produit produit = dao.trouver(Long.valueOf(request.getParameter("id")));
                if (produit == null) {
                    request.getSession().setAttribute("erreur", "Ce produit n'existe plus.");
                } else {
                    request.setAttribute("edit", produit);
                }
            } catch (RuntimeException exception) {
                request.getSession().setAttribute("erreur", message(exception));
            }
        }

        List<Produit> produits = dao.tous();
        long stockTotal = 0;
        long produitsEpuises = 0;
        for (Produit produit : produits) {
            stockTotal += produit.getStock();
            if (produit.getStock() == 0) {
                produitsEpuises++;
            }
        }
        request.setAttribute("produits", produits);
        request.setAttribute("produitsCount", produits.size());
        request.setAttribute("stockTotal", stockTotal);
        request.setAttribute("produitsEpuises", produitsEpuises);
        request.getRequestDispatcher("/WEB-INF/views/produits.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("supprimer".equals(action)) {
                dao.supprimer(Long.valueOf(request.getParameter("id")));
                request.getSession().setAttribute("message", "Produit supprimé.");
            } else if ("ajouter".equals(action) || "modifier".equals(action)) {
                String nom = required(request.getParameter("nom"), "Le nom est obligatoire.");
                String description = request.getParameter("description");
                double prix = Double.parseDouble(request.getParameter("prix"));
                int stock = Integer.parseInt(request.getParameter("stock"));
                if (!Double.isFinite(prix) || prix < 0 || stock < 0) {
                    throw new IllegalArgumentException("Le prix et le stock doivent être positifs.");
                }

                if ("modifier".equals(action)) {
                    dao.modifier(
                            Long.valueOf(request.getParameter("id")), nom, description, prix, stock);
                    request.getSession().setAttribute("message", "Modifications enregistrées.");
                } else {
                    dao.ajouter(new Produit(nom, description, prix, stock));
                    request.getSession().setAttribute("message", "Produit ajouté au catalogue.");
                }
            } else {
                throw new IllegalArgumentException("Action inconnue.");
            }
        } catch (Exception exception) {
            request.getSession().setAttribute("erreur", message(exception));
        }

        response.sendRedirect(request.getContextPath() + "/produits");
    }

    private static String required(String value, String errorMessage) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(errorMessage);
        }
        return value.trim();
    }

    private static String message(Exception exception) {
        return exception.getMessage() == null ? "L'opération n'a pas pu aboutir." : exception.getMessage();
    }
}