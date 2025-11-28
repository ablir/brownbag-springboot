'use client';

import { signOut } from 'next-auth/react';
import Image from 'next/image';

interface UserData {
  id: string;
  username: string;
  email: string;
  firstName: string;
  lastName: string;
  avatar: string;
  phone: string;
  address: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
    country: string;
  };
  company: string;
  jobTitle: string;
  bio: string;
  joinedDate: string;
  lastLogin: string;
}

export default function UserProfile({ user }: { user: UserData }) {
  const handleLogout = async () => {
    await signOut({ callbackUrl: '/login' });
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      {/* Header */}
      <header className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex justify-between items-center">
            <h1 className="text-2xl font-bold text-gray-900">User Dashboard</h1>
            <button
              onClick={handleLogout}
              className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition"
            >
              Logout
            </button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Profile Header */}
        <div className="bg-white rounded-lg shadow-md p-6 mb-6">
          <div className="flex items-center space-x-6">
            <div className="relative w-24 h-24 rounded-full overflow-hidden">
              <Image
                src={user.avatar || '/placeholder-avatar.png'}
                alt={`${user.firstName} ${user.lastName}`}
                fill
                className="object-cover"
              />
            </div>
            <div>
              <h2 className="text-3xl font-bold text-gray-900">
                {user.firstName} {user.lastName}
              </h2>
              <p className="text-gray-600">@{user.username}</p>
              <p className="text-gray-500 mt-2">{user.bio}</p>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Personal Information */}
          <div className="bg-white rounded-lg shadow-md p-6">
            <h3 className="text-xl font-semibold text-gray-900 mb-4">
              Personal Information
            </h3>
            <div className="space-y-3">
              <InfoRow label="Email" value={user.email} />
              <InfoRow label="Phone" value={user.phone} />
              <InfoRow label="User ID" value={user.id} />
            </div>
          </div>

          {/* Work Information */}
          <div className="bg-white rounded-lg shadow-md p-6">
            <h3 className="text-xl font-semibold text-gray-900 mb-4">
              Work Information
            </h3>
            <div className="space-y-3">
              <InfoRow label="Company" value={user.company} />
              <InfoRow label="Job Title" value={user.jobTitle} />
            </div>
          </div>

          {/* Address */}
          <div className="bg-white rounded-lg shadow-md p-6">
            <h3 className="text-xl font-semibold text-gray-900 mb-4">Address</h3>
            <div className="space-y-3">
              <InfoRow label="Street" value={user.address.street} />
              <InfoRow label="City" value={user.address.city} />
              <InfoRow label="State" value={user.address.state} />
              <InfoRow label="ZIP Code" value={user.address.zipCode} />
              <InfoRow label="Country" value={user.address.country} />
            </div>
          </div>

          {/* Activity */}
          <div className="bg-white rounded-lg shadow-md p-6">
            <h3 className="text-xl font-semibold text-gray-900 mb-4">Activity</h3>
            <div className="space-y-3">
              <InfoRow
                label="Joined"
                value={new Date(user.joinedDate).toLocaleDateString()}
              />
              <InfoRow
                label="Last Login"
                value={new Date(user.lastLogin).toLocaleDateString()}
              />
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between items-center py-2 border-b border-gray-100 last:border-0">
      <span className="text-gray-600 font-medium">{label}:</span>
      <span className="text-gray-900">{value}</span>
    </div>
  );
}
