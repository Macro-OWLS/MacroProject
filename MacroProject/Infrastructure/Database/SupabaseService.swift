import Foundation
import Supabase
import PostgREST

public class SupabaseService {
    public static var shared = SupabaseService()
    private let client: SupabaseClient
    
    private init() {
        guard let url = URL(string: "https://pdewsycvbfrmvivixsiy.supabase.co") else {
            fatalError("Invalid Supabase URL")
        }
        
        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBkZXdzeWN2YmZybXZpdml4c2l5Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyNzk0MzcwMSwiZXhwIjoyMDQzNTE5NzAxfQ.7AeqhhAqON6T955U3lhAQ-8d1LNK1LQ1SSFTsV_-ln8"
        )
    }
    
    public func getClient() -> SupabaseClient {
        return client
    }
}


