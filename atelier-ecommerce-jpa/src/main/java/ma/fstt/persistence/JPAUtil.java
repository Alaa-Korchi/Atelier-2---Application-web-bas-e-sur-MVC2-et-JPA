
package ma.fstt.persistence;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public final class JPAUtil {

    private static final EntityManagerFactory EMF =
            Persistence.createEntityManagerFactory("ecommercePU");

    private JPAUtil() {
        // Empêche l'instanciation de cette classe
    }

    public static EntityManagerFactory getEmf() {
        return EMF;
    }
}
