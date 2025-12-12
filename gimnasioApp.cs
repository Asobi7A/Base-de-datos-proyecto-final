using System;
using System.Data;
using System.Data.SqlClient;

class Program
{
    // 🔴 CAMBIA ESTA CADENA SI ES NECESARIO
    const string connectionString =
        "Server=.;Database=Gimnasio_PF;Integrated Security=True;";

    static void Main()
    {
        Console.WriteLine("=== REGISTRO DE NUEVO SOCIO ===");
        Console.WriteLine();

        try
        {
            // 1) Mostrar opciones desde la base
            MostrarMembresias();
            Console.WriteLine();
            MostrarClases();
            Console.WriteLine();

            // 2) Leer datos de la persona
            Console.Write("Nombre: ");
            string nombre = Console.ReadLine() ?? "";

            Console.Write("Apellido: ");
            string apellido = Console.ReadLine() ?? "";

            Console.Write("CI: ");
            string ci = Console.ReadLine() ?? "";

            Console.Write("Fecha de nacimiento (yyyy-mm-dd): ");
            DateTime fechaNac = DateTime.Parse(Console.ReadLine() ?? "2000-01-01");

            Console.Write("Telefono: ");
            string telefono = Console.ReadLine() ?? "";

            Console.Write("Email: ");
            string email = Console.ReadLine() ?? "";

            Console.Write("Direccion: ");
            string direccion = Console.ReadLine() ?? "";

            // 3) Membresía opcional
            Console.Write("ID de membresia seleccionada (ENTER para ninguna): ");
            string inputM = Console.ReadLine();

            int? idMembresia = null;
            if (!string.IsNullOrWhiteSpace(inputM))
                idMembresia = int.Parse(inputM);

            // 4) Clase opcional
            Console.Write("ID de clase seleccionada (ENTER para ninguna): ");
            string inputC = Console.ReadLine();

            int? idClase = null;
            if (!string.IsNullOrWhiteSpace(inputC))
                idClase = int.Parse(inputC);

            // 5) Guardar en la base (persona + socio + claseInscrita)
            RegistrarSocioCompleto(
                nombre, apellido, ci, fechaNac,
                telefono, email, direccion,
                idMembresia, idClase
            );

            Console.WriteLine();
            Console.WriteLine("✅ Socio registrado con exito.");
        }
        catch (Exception ex)
        {
            Console.WriteLine();
            Console.WriteLine("❌ Error: " + ex.Message);
        }

        Console.WriteLine();
        Console.WriteLine("Presiona ENTER para salir...");
        Console.ReadLine();
    }

    // Muestra las membresias disponibles
    static void MostrarMembresias()
    {
        Console.WriteLine("=== MEMBRESIAS DISPONIBLES ===");

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string sql = "SELECT ID_membresia, Tipo, Precio FROM membresia";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    int id = dr.GetInt32(0);
                    string tipo = dr.GetString(1);
                    decimal precio = dr.GetDecimal(2);

                    Console.WriteLine($"ID {id} - {tipo} ({precio} Bs/mes)");
                }
            }
        }
    }

    // Muestra las clases disponibles
    static void MostrarClases()
    {
        Console.WriteLine("=== CLASES DISPONIBLES ===");

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string sql = "SELECT ID_clase, Nombre, Precio FROM clase";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    int id = dr.GetInt32(0);
                    string nombre = dr.GetString(1);
                    decimal precio = dr.GetDecimal(2);

                    Console.WriteLine($"ID {id} - {nombre} ({precio} Bs/mes)");
                }
            }
        }
    }

    // Hace los INSERT en persona, socio y claseInscrita
    static void RegistrarSocioCompleto(
        string nombre, string apellido, string ci, DateTime fechaNac,
        string telefono, string email, string direccion,
        int? idMembresia, int? idClase)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            SqlTransaction tx = conn.BeginTransaction();

            try
            {
                // 1) persona
                int idPersona = InsertarPersona(conn, tx, nombre, apellido, ci,
                                                fechaNac, telefono, email, direccion);

                // 2) socio (membresía puede ser NULL)
                int idSocio = InsertarSocio(conn, tx, idPersona, idMembresia);

                // 3) claseInscrita (solo si hay clase)
                if (idClase != null)
                    InsertarClaseInscrita(conn, tx, idSocio, idClase.Value);

                tx.Commit();
            }
            catch
            {
                tx.Rollback();
                throw;
            }
        }
    }

    static int InsertarPersona(SqlConnection conn, SqlTransaction tx,
        string nombre, string apellido, string ci, DateTime fechaNac,
        string telefono, string email, string direccion)
    {
        string sql = @"
            INSERT INTO persona (Nombre, Apellido, CI, FechaNacimiento, Telefono, Email, Direccion)
            VALUES (@Nombre, @Apellido, @CI, @FechaNacimiento, @Telefono, @Email, @Direccion);
            SELECT SCOPE_IDENTITY();";

        using (SqlCommand cmd = new SqlCommand(sql, conn, tx))
        {
            cmd.Parameters.AddWithValue("@Nombre", nombre);
            cmd.Parameters.AddWithValue("@Apellido", apellido);
            cmd.Parameters.AddWithValue("@CI", ci);
            cmd.Parameters.AddWithValue("@FechaNacimiento", fechaNac);
            cmd.Parameters.AddWithValue("@Telefono", (object)telefono ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Email", (object)email ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Direccion", (object)direccion ?? DBNull.Value);

            return Convert.ToInt32(cmd.ExecuteScalar());
        }
    }

    static int InsertarSocio(SqlConnection conn, SqlTransaction tx,
        int idPersona, int? idMembresia)
    {
        string sql = @"
            INSERT INTO socio (ID_persona, FechaRegistro, Estado, ID_membresia)
            VALUES (@ID_persona, GETDATE(), 'Activo', @ID_membresia);
            SELECT SCOPE_IDENTITY();";

        using (SqlCommand cmd = new SqlCommand(sql, conn, tx))
        {
            cmd.Parameters.AddWithValue("@ID_persona", idPersona);
            cmd.Parameters.AddWithValue("@ID_membresia", (object)idMembresia ?? DBNull.Value);

            return Convert.ToInt32(cmd.ExecuteScalar());
        }
    }

    static void InsertarClaseInscrita(SqlConnection conn, SqlTransaction tx,
        int idSocio, int idClase)
    {
        string sql = @"
            INSERT INTO claseInscrita (ID_socio, ID_clase, FechaInscripcion, Estado)
            VALUES (@ID_socio, @ID_clase, GETDATE(), 'Activo');";

        using (SqlCommand cmd = new SqlCommand(sql, conn, tx))
        {
            cmd.Parameters.AddWithValue("@ID_socio", idSocio);
            cmd.Parameters.AddWithValue("@ID_clase", idClase);
            cmd.ExecuteNonQuery();
        }
    }
}
