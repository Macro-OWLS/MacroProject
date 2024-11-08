import Foundation
import Supabase
import PostgREST

public class SupabaseService {
    public static var shared = SupabaseService()
    private let client: SupabaseClient
    
    private init() {
        guard let url = URL(string: "https://enxiywvjtgwszevjidsu.supabase.co") else {
            fatalError("Invalid Supabase URL")
        }
        
        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVueGl5d3ZqdGd3c3pldmppZHN1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA3ODIwMDEsImV4cCI6MjA0NjM1ODAwMX0.Hqty5DJXAG-eInaDa6JMrX4RUkpRifRQncIUleeNxqA"
        )
    }
    
    public func getClient() -> SupabaseClient {
        return client
    }
}


