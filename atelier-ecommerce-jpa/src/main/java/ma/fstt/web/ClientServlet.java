package ma.fstt.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ma.fstt.dao.ClientDAO;
import ma.fstt.model.Client;

import java.io.IOException;
import java.util.List;

@WebServlet("/clients")
public class ClientServlet extends HttpServlet {
    private final ClientDAO dao = new ClientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("editer".equals(request.getParameter("action"))) {
            try {
                Client client = dao.trouver(Long.valueOf(request.getParameter("id")));
                if (client == null) {
                    request.getSession().setAttribute("erreur", "Ce client n'existe plus.");
                } else {
                    request.setAttribute("edit", client);
                }
            } catch (RuntimeException exception) {
                request.getSession().setAttribute("erreur", message(exception));
            }
        }

        List<Client> clients = dao.tous();
        request.setAttribute("clients", clients);
        request.setAttribute("clientsCount", clients.size());
        request.getRequestDispatcher("/WEB-INF/views/clients.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("supprimer".equals(action)) {
                dao.supprimer(Long.valueOf(request.getParameter("id")));
                request.getSession().setAttribute("message", "Client supprimé.");
            } else if ("modifier".equals(action)) {
                String nom = required(request.getParameter("nom"), "Le nom est obligatoire.");
                String email = required(request.getParameter("email"), "L'e-mail est obligatoire.");
                dao.modifier(Long.valueOf(request.getParameter("id")), nom, email);
                request.getSession().setAttribute("message", "Modifications enregistrées.");
            } else if ("ajouter".equals(action)) {
                String nom = required(request.getParameter("nom"), "Le nom est obligatoire.");
                String email = required(request.getParameter("email"), "L'e-mail est obligatoire.");
                dao.ajouter(new Client(nom, email));
                request.getSession().setAttribute("message", "Client ajouté.");
            } else {
                throw new IllegalArgumentException("Action inconnue.");
            }
        } catch (Exception exception) {
            request.getSession().setAttribute("erreur", message(exception));
        }

        response.sendRedirect(request.getContextPath() + "/clients");
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