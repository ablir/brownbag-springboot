import { redirect } from 'next/navigation';
import { signIn, auth } from '@/auth';
import LoginForm from './login-form';

export default async function LoginPage() {
  const session = await auth();

  if (session) {
    redirect('/dashboard');
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="bg-white p-8 rounded-lg shadow-lg w-full max-w-md">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-800 mb-2">Welcome Back</h1>
          <p className="text-gray-600">Sign in to your account</p>
        </div>

        <LoginForm />

        <div className="mt-6 text-center text-sm text-gray-500">
          <p>This is a demo app - use any credentials to login</p>
        </div>
      </div>
    </div>
  );
}
