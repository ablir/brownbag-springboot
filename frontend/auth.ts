import NextAuth from 'next-auth';
import Credentials from 'next-auth/providers/credentials';

export const { handlers, signIn, signOut, auth } = NextAuth({
  providers: [
    Credentials({
      name: 'Credentials',
      credentials: {
        username: { label: 'Username', type: 'text' },
        password: { label: 'Password', type: 'password' },
      },
      async authorize(credentials) {
        if (!credentials?.username || !credentials?.password) {
          return null;
        }

        try {
          // Call the backend API for authentication
          const response = await fetch('http://localhost:3001/api/login', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              username: credentials.username,
              password: credentials.password,
            }),
          });

          const data = await response.json();

          if (response.ok && data.success) {
            // Return user object with required fields
            return {
              id: credentials.username as string,
              name: credentials.username as string,
              email: `${credentials.username}@example.com`,
              token: data.token,
            };
          }

          return null;
        } catch (error) {
          console.error('Authentication error:', error);
          return null;
        }
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id;
        token.username = user.name;
        token.accessToken = (user as any).token;
      }
      return token;
    },
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.id as string;
        session.user.name = token.username as string;
        (session as any).accessToken = token.accessToken;
      }
      return session;
    },
    authorized({ request, auth }) {
      const { pathname } = request.nextUrl;
      const isAuthenticated = !!auth;
      const isLoginPage = pathname === '/login';
      const isHomePage = pathname === '/';

      // Allow access to login page only when not authenticated
      if (isLoginPage) {
        return !isAuthenticated;
      }

      // Redirect home to login or dashboard
      if (isHomePage) {
        return true; // Let the page handle the redirect
      }

      // All other pages require authentication
      return isAuthenticated;
    },
  },
  pages: {
    signIn: '/login',
  },
  session: {
    strategy: 'jwt',
  },
});
