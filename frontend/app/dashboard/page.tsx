import { auth } from '@/auth';
import { redirect } from 'next/navigation';
import UserProfile from './user-profile';

export default async function DashboardPage() {
  const session = await auth();

  if (!session?.user) {
    redirect('/login');
  }

  // Fetch user data from backend
  const username = session.user.name || 'user';
  const response = await fetch(
    `http://localhost:3001/api/user/info?username=${username}`,
    {
      cache: 'no-store',
    }
  );

  const userData = await response.json();

  return <UserProfile user={userData} />;
}
