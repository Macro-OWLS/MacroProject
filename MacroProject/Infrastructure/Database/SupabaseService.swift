import Foundation
import Supabase


public class SupabaseService{
    private static var shared = SupabaseService()
    private let client: SupabaseClient
    
    init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://pdewsycvbfrmvivixsiy.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBkZXdzeWN2YmZybXZpdml4c2l5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc5NDM3MDEsImV4cCI6MjA0MzUxOTcwMX0.YtK5M3TeVds-XAI5BAbkx1ZHC7fHTiQBvHzpLuo7cWc"
        )
    }

}




